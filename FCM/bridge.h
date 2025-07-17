//
// bridge.h
// FridaCodeManager
//
// Created by SeanIsNotAConstant on 21.10.24
//

#ifndef BRIDGE_H
#define BRIDGE_H

#import <Foundation/Foundation.h>

// MARK: –––––––––––– Stubs for jailbreak-only APIs ––––––––––––

// دالة libroot_dyn_get_jbroot_prefix() كانت تُعيد مسار الجيلبريك
// نستبدلها ستبّ يقوم بإرجاع سلسلة فارغة
static inline const char * libroot_dyn_get_jbroot_prefix(void) {
    return "";
}

// دالة altroot(inPath:) كانت تبحث عن بديل للمسار ضمن الجيلبريك
// نستبدلها ستبّ يعيد nil
static inline NSURL * _Nullable altroot(NSString *path) {
    return nil;
}

// MARK: –––––––––––– FCM & Other Libraries ––––––––––––

// إذا كنت تريد دمج وظائف FCM داخل التطبيق نفسه،
// يمكنك استيراد الهيدر الخاص بها بعد تضمينها كمكتبة ثابتة (static library)
// مثال:
// #import "FCM.h"
// #import "FLoad.h"
// #import "Proc.h"

// أما إذا لم تعد بحاجة لها، فقط اتركها معلقة أو احذفها.

// MARK: –––––––––––– libzip & dycall & check & server ––––––––––––

// إذا قمت بدمج هذه المكتبات في تطبيقك (كمكتبات iOS frameworks أو ملفات ثابتة):
// #import <libzip/libzip.h>
// #import <libdycall/dyexec.h>
// #import <libcheck/check.h>
// #import <libserver/server.h>

// وإلا يمكنك إزالة هذه الأسطر أيضاً.

#endif // BRIDGE_H
