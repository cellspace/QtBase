#ifndef TEST_H
#define TEST_H

#include <QObject>

class Test : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString strTest READ strTest WRITE setStrTest NOTIFY strTestChanged)
    Q_PROPERTY(QString strMemberTest MEMBER mMemberTest NOTIFY strMemberTestChange)
public:
    explicit Test(QObject *parent = nullptr);

    QString strTest() const;
    //void setStrTest(const QString &strTest);

public slots:
    void setStrTest(const QString &strTest);

signals:
    void strTestChanged();
    void strMemberTestChange();

private:
    QString mStrTest;
    QString mMemberTest;
};

#endif // TEST_H
