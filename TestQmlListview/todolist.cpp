#include<QDebug>

#include "todolist.h"

ToDoList::ToDoList(QObject *parent)
    : QObject(parent)
    , mBtnText(SelectAll)
{
    mItems.append({QStringLiteral("item 1"), true});
    mItems.append({QStringLiteral("item 2"), false});
    mItems.append({QStringLiteral("item 3"), true});
    mItems.append({QStringLiteral("item 4"), false});
}

QVector<ToDoItem> ToDoList::items() const
{
    return mItems;
}

bool ToDoList::setItemAt(int index, const ToDoItem &item)
{
    if(index < 0 || index >= mItems.size())
        return false;
    const ToDoItem &oldItem = mItems.at(index);
    if(item.description==oldItem.description && item.selected==oldItem.selected)
        return false;
    bool selChanged = false;
    if(item.selected != oldItem.selected)
        selChanged = true;
    mItems[index] = item; //mItems.insert(index, item);
    if(selChanged)
    {
        bool allSelected = true;
        for(auto &item : mItems)
        {
            if(!item.selected)
            {
                allSelected = false;
                break;
            }
        }
        if(allSelected)
        {
            setBtnText(QString(DeselectAll));
        }
        else
        {
            setBtnText(QString(SelectAll));
        }
    }
    return true;
}

void ToDoList::appendItem()
{
    emit preItemAppended();
    ToDoItem item;
    item.selected = false;
    mItems.append(item);
    emit postItemAppended();
}

void ToDoList::removeCompletedItems()
{
    for(int i=0; i<mItems.size();)
    {
        if(mItems.at(i).selected)
        {
            emit preItemRemoved(i);
            mItems.remove(i);
            emit postItemRemoved();
        }
        else
        {
            ++ i;
        }
    }

}

QString ToDoList::btnText() const
{
    return mBtnText;
}

void ToDoList::setBtnText(const QString &btnText)
{
    if(mBtnText != btnText)
    {
        mBtnText = btnText;
        btnTextChanged();
    }
}

void ToDoList::selDeselButtonClicked(const QString& btnText)
{
    qDebug() << btnText;
    emit preSelDeselAll();
    if(btnText == QString(SelectAll))
    {
        for(auto &item : mItems)
        {
            if(!item.selected)
                item.selected = true;
        }
        setBtnText(QString(DeselectAll));
    }
    else
    {
        for(auto &item : mItems)
        {
            if(item.selected)
                item.selected = false;
        }
        setBtnText(QString(SelectAll));
    }
    emit postSelDeselAll();
}

