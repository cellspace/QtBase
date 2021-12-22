#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "todolist.h"
#include "todomodel.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    qmlRegisterType<ToDoModel>("ToDo", 1, 0, "ToDoModel"); //register c++ code to Qml type system [import ToDo 1.0  / ToDoModel ]
    //force the ToDoList as a qml type so it can be used as a property of ToDoModel
    //as it is a back-end type, we don't intend for it to be created in qml, so use 'qmlRegisterUncreatableType'
    qmlRegisterUncreatableType<ToDoList>("ToDo", 1, 0, "ToDoList", QStringLiteral("ToDoList should not be created in Qml"));
    ToDoList toDoList;
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    engine.rootContext()->setContextProperty(QStringLiteral("toDoList"), &toDoList); //expose 'toDoList' to Qml
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
