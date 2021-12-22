#include <qdebug.h>

#include "test.h"

Test::Test(QObject *parent) : QObject(parent),
    mStrTest("mStrTest"), mMemberTest("mMemberTest")
{
}

QString Test::strTest() const
{
    return mStrTest;
}

void Test::setStrTest(const QString &strTest)
{
    qDebug() << "[Test::setStrTest] strTest=" << strTest;
    qDebug() << "[Test::setStrTest] mMemberTest=" << mMemberTest;
    if(strTest == mStrTest)
        return ;
    mStrTest = strTest;
    emit strTestChanged();
}
