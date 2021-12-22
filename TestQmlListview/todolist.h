#ifndef TODOLIST_H
#define TODOLIST_H

#include <QObject>
#include <QVector>

struct ToDoItem
{
    QString description;
    bool selected;
};


class ToDoList : public QObject
{
    static constexpr auto SelectAll = "Select ALL";
    static constexpr auto DeselectAll = "Deselect All";
    Q_OBJECT
    Q_PROPERTY(QString btnText READ btnText WRITE setBtnText NOTIFY btnTextChanged)
public:
    explicit ToDoList(QObject *parent = nullptr);

    QVector<ToDoItem> items() const;
    bool setItemAt(int index, const ToDoItem &item);

    QString btnText() const;
    void setBtnText(const QString &btnText);

signals:
    void preItemAppended();
    void postItemAppended();
    void preItemRemoved(int index);
    void postItemRemoved();
    void preSelDeselAll();
    void postSelDeselAll();
    void btnTextChanged();

public slots:
    void appendItem();
    void removeCompletedItems();
    void selDeselButtonClicked(const QString& btnText);

private:
    QVector<ToDoItem> mItems;
    QString mBtnText;
};

#endif // TODOLIST_H
