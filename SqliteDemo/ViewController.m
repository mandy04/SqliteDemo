//
//  ViewController.m
//  SqliteDemo
//
//  Created by llbt on 16/3/29.
//  Copyright © 2016年 llbt. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>

@interface ViewController ()
{
    sqlite3 *database;
}
@end


/**
 *  sqlite执行查询语句时需要回调函数,第一个参数是sqlite3_exec时传入的void ＊参数，第二个参数是表中的字段个数，第三个是字段值，第四个是字段名，后两个参数都是字符串数组
 */

int myCallBack(void *para,int column_count, char **column_value, char **column_name){
    
    for (int i = 0; i <column_count; i++) {
        NSLog(@"%s : %s",column_name[i],column_value[i]);
    }
    return 0;
}
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *dbFile  = [documentPath stringByAppendingString:@"/student.sqlite"];
    NSLog(@"%@",dbFile);
    
    //创建数据库
    if (sqlite3_open([dbFile UTF8String], &database) == SQLITE_OK) {
        
        NSLog(@"open success");

        //创建一条sql语句（id 整型,主键，自增， name,sex,class 文本类型）
        const char *createSql = "create table if not exists student (id integer primary key autoincrement,name text,sex text,class text);";
        //创建错误信息
        char *err;
        if (sqlite3_exec(database, createSql, NULL, NULL, &err) != SQLITE_OK) {
            //返回值不为0，sql语句执行失败
           NSLog(@"create table fail");
        }
        
        /**
         *  增加数据
         *
         *  @param id    编号
         *  @param name  姓名
         *  @param sex   性别
         *  @param class 班级
         *
         *  @return 一跳数据
         */
        
/**
        const char *insertSql1 = "insert into student(id, name, sex, class) values (3, 'mondy', 'femail', '语文')";
        
        const char *insertSql2 = "insert into student(id, name, sex, class) values (4, 'monkey', 'mail', '工程造价')";
        //调用执行语句
        if (sqlite3_exec(database, insertSql1, NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"create record fail 1");
        }
        
        if (sqlite3_exec(database, insertSql2, NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"create record fail 2");
        }

*/
        /**
         *删除语句
         *
         */
/*
        const char *delateSql = "delete from student where id = 2";
        if (sqlite3_exec(database, delateSql, NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"delette fail");
        }
        
*/
        /**
         *  更新语句
         *
         */
/**
        const char *updateSql = "update student set name = 'kobe' where id = 1";
        //执行更新操作
        if (sqlite3_exec(database, updateSql, NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"update record fail");
        }
        
*/
        
        /**
         *  查询
         *查询数据表中所有  callback回调函数作为参数  "select  from student where 字段名 ＝ 你想查询的值"
         */
/*
        const char *selectSql = "select * from student";
        if (sqlite3_exec(database, selectSql, myCallBack, NULL, &err) != SQLITE_OK) {
            NSLog(@"select data fail");
        }
        
 */
        /**
         *  查询方式2  若用到二进制文件时使用这个
         */
        const char *selectSql = "select * from student";
        sqlite3_stmt *statement;
        
        //把一个sql语句解析到statement中，当prepare成功之后开始查询语句
        
        if (sqlite3_prepare_v2(database, selectSql, -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSLog(@"id = %d,name = %s,sex = %s , class= %s ",sqlite3_column_int(statement, 0),sqlite3_column_text(statement, 1),sqlite3_column_text(statement, 2),sqlite3_column_text(statement, 3));
            }
        }else {
            NSLog(@"search fail");
        }
        
        //析构sqlite3_prepare_v2创建的语句
        sqlite3_finalize(statement);
        
        
    }else
    {
        NSLog(@"open fail");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
