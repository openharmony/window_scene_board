/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { LogDomain, LogHelper, ThreadUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CustomPromise } from '@ohos/frameworkwrapper/src/main/ets/base/CustomPromise';
import { cloneSerializableProperties, messageChannel } from './MessageChannel';
import { SystemUICcmConfig } from '../utils/SystemUICcmConfig';
import process from '@ohos.process';

const TAG = 'ThreadCall';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

// 函数占位字符串，跨线程场景需要把回调函数转换成message消息
const FN_NAME_PLACE_HOLDER = 'FN_NAME_PLACE_HOLDER';

// 跨线程调用类型
export enum ThreadCallType {
  // 发message调用主线程同步函数
  Msg = 0,
  // 同步调用主线程同步函数。会阻塞子线程，调用对于子线程是同步的，对于主线程是异步的。
  Sync = 1,
  // 发message调用主线程异步函数
  Async = 2,
  // 注册回调
  Register = 3,
  // 解注册回调
  UnRegister = 4,
  // 单次注册回调
  RegisterOnce = 5,
}

// 跨线程注册interface通用类型
export interface ThreadCallCommRegisterIntf {
  callback: Function
}

// Register类型跨线程注册map，用于UnRegister移除监听。
const registerMap: Map<string, object[]> = new Map();
// Msg类型调用，主线程监听map，避免重复监听
const onMessageMap: Map<string, boolean> = new Map();
// 跨线程注册registerCallObject对象map，避免重复注册
const callObjectMap: Map<string, boolean> = new Map();

/**
 * 需要处理跨线程调用的方法装饰器工厂
 * @param callType 调用类型。同步/异步
 * @returns 属性描述符
 */
export function threadCall(callType: ThreadCallType = ThreadCallType.Msg) {
  return (target: object | Function, method: string,
    descriptor: PropertyDescriptor): PropertyDescriptor => {
    log.showDebug(`callType ${callType} ${method} tid: ${messageChannel.tid}`);
    try {
      if (ThreadUtil.isMainThread) {
        // 主线程
        return threadCallMain(target, method, descriptor, callType);
      } else if (process.tid === messageChannel.tid) {
        // sysUI子线程
        return threadCallSub(target, method, descriptor, callType);
      } else {
        // 其他情况，例如被taskpool引用
        return descriptor;
      }
    } catch (e) {
      log.error(`Thread call error: ${e}`);
      return descriptor;
    }
  };
}

/**
 * 主线程处理
 * @param target 对于静态成员来说是类的构造函数，对于实例成员是类的原型对象。
 * @param descriptor 属性描述符
 * @param callType 调用类型。同步/异步
 * @returns 新的属性描述符
 */
function threadCallMain(target: object | Function, method: string, descriptor: PropertyDescriptor,
  callType: ThreadCallType): PropertyDescriptor {
  // 不启用worker时无需处理。
  if (!SystemUICcmConfig.instance.isEnabledWorker) {
    return descriptor;
  }

  const originalMethod: Function = descriptor.value;
  const callObjName: string = getTargetCallObjName(target);

  let callObj: Object = getTargetCallObj(target);
  if (!callObj) {
    return descriptor;
  }

  if (isNeedDescriptorToMsg(callType)) {
    addMainOnMsg(callObjName, method, descriptor, callObj);
  } else {
    // 主线程注册，会和单例的Singleton.decorate()静态属性装饰器冲突。建议使用SingletonHelper.createFactory创建单例。
    registerCallObject(callObjName, callObj);
  }

  descriptor.value = (...args: Object[]): void | Object => {
    const uid = args.pop() as string;
    // 1.方法在主线程直接调用
    if (!isThreadCallUid(uid)) {
      return callFromMainThread(originalMethod, args, callObj, uid);
    }

    log.showInfo(`threadCallMain uid ${uid}`)

    // 2.子线程调用主线程方法场景
    // 对象属性中存在回调函数时，将回调函数转换为跨线程的Message消息回调
    if (isNeedTransFn(callType)) {
      args.forEach((arg, index): void => {
        covertFnToSendMsg(arg, index, uid);
      });
    }

    if (callType === ThreadCallType.Msg) {
      return mainDescriptorMsg(originalMethod, args, callObj, uid);
    }
    if (callType === ThreadCallType.Sync) {
      return mainDescriptorSync(originalMethod, args, callObj, uid);
    }
    if (callType === ThreadCallType.Async) {
      return mainDescriptorAsync(originalMethod, args, callObj, uid);
    }
    if (callType === ThreadCallType.Register || ThreadCallType.RegisterOnce) {
      return mainDescriptorRegister(originalMethod, args, callObj, uid);
    }
    if (callType === ThreadCallType.UnRegister) {
      return mainDescriptorUnRegister(originalMethod, callObj, uid);
    }

    return undefined;
  };

  return descriptor;
}

/**
 * 子线程处理
 * @param target 对于静态成员来说是类的构造函数，对于实例成员是类的原型对象。
 * @param method 待调用方法
 * @param descriptor 属性描述符
 * @param callType 调用类型。同步/异步
 * @returns 新的属性描述符
 */
function threadCallSub(target: object | Function, method: string,
  descriptor: PropertyDescriptor, callType: ThreadCallType): PropertyDescriptor {
  const callObjName: string = getTargetCallObjName(target);

  descriptor.value = (...args: Object[]): void | Object => {
    const uid: string = getUid(callType, args);
    log.showInfo(`threadCallSub ${callObjName} ${method} uid: ${uid}`);

    // 对象属性中存在回调函数时，将回调函数转换为跨线程的Message消息回调
    if (isNeedTransFn(callType)) {
      args.forEach((arg, index) => {
        args[index] = covertFnToOnMsg(arg, index, uid, callType);
      });
    } else {
      args = cloneSerializableProperties(args);
    }

    if (callType === ThreadCallType.Msg) {
      return subDescriptorMsg(callObjName, method, args, uid);
    }
    if (callType === ThreadCallType.Sync) {
      return subDescriptorSync(callObjName, method, args);
    }
    if (callType === ThreadCallType.Async) {
      return subDescriptorAsync(callObjName, method, args, uid);
    }
    if (callType === ThreadCallType.Register || ThreadCallType.RegisterOnce) {
      return subDescriptorRegister(callObjName, method, args, uid);
    }
    if (callType === ThreadCallType.UnRegister) {
      return subDescriptorUnRegister(callObjName, method, uid);
    }

    return undefined;
  };

  return descriptor;
}

/**
 * 判断是否为uid参数
 * @param uid 跨线程调用uid标识
 * @returns
 */
function isThreadCallUid(uid: string): boolean {
  return typeof uid === 'string' && uid.startsWith(`${TAG}_`);
}

/**
 * 每次调用生成一个uid标识
 * @returns
 */
function getUid(callType: ThreadCallType, args: Object[]): string {
  let uid: string;
  if (callType === ThreadCallType.Register || callType === ThreadCallType.UnRegister) {
    uid = TAG + '_' + args.pop();
  } else {
    uid = TAG + '_' + Date.now().toString(36) + Math.random().toString(36).substring(2);
  }

  args.push(uid);
  return uid;
}

/**
 * 生成回调函数标识
 * @param uid 本次调用的uid
 * @param index 参数对象index
 * @param fnName 函数名
 * @returns
 */
function getCallBackMsgName(uid: string, index: number, fnName: string): string {
  return uid + '_' + index + '_' + fnName;
}

/**
 * 主线程 将对象中的回调函数方法转换为Send Message
 * @param arg 调用参数
 * @param index 参数索引
 * @param uid 跨线程调用uid标识
 */
function covertFnToSendMsg(arg: Object, index: number, uid: string): void {
  if (!isValidObj(arg)) {
    return;
  }

  Object.getOwnPropertyNames(arg).forEach((key: string): void => {
    if (arg[key] !== FN_NAME_PLACE_HOLDER) {
      return;
    }
    const msgName = getCallBackMsgName(uid, index, key);
    log.showInfo(`covertFnToSendMsg ${msgName}`);

    arg[key] = (...resArr: Object[]): void => {
      const resultArr: Object[] = [];
      resArr.forEach(res => {
        resultArr.push(cloneSerializableProperties(res));
      });

      log.showInfo(`sendMessage ${msgName}`);
      messageChannel.sendMessage(msgName, resultArr);
    };
  });
}

/**
 * 子线程 将对象中的回调函数方法转换为On Message
 * @param arg 调用参数
 * @param index 参数索引
 * @param uid 跨线程调用uid标识
 */
function covertFnToOnMsg(arg: Object, index: number, uid: string, callType: ThreadCallType): Object {
  if (!isValidObj(arg)) {
    return arg;
  }

  const newArg: Object = {};
  Object.getOwnPropertyNames(arg).forEach((key) => {
    if (typeof arg[key] !== 'function') {
      newArg[key] = arg[key];
      return;
    }
    log.showInfo(`covertFnToOnMsg key: ${key}`)
    newArg[key] = FN_NAME_PLACE_HOLDER;

    const fn: Function = arg[key];
    // 回调函数通过Message消息接收回调
    const msgName = getCallBackMsgName(uid, index, key);

    // 注册
    if (callType === ThreadCallType.Register) {
      log.showInfo(`Set Register ${msgName}`)
      const callBack = (res: object[]): void => {
        log.showInfo(`Register onMessage ${msgName}`)
        fn(...res);
      }
      messageChannel.onMessage(msgName, callBack);
      return;
    }

    // 解注册
    if (callType === ThreadCallType.UnRegister) {
      log.showInfo(`offMessage ${msgName}`)
      messageChannel.offAllMessage(msgName);
      return;
    }

    // 一次性注册
    if (callType === ThreadCallType.RegisterOnce) {
      log.showInfo(`set RegisterOnce ${msgName}`)
      const callBack = (res: object[]): void => {
        log.showInfo(`RegisterOnce onMessage ${msgName}`);
        offMsgForRegisterOnce(newArg, uid, index);
        fn(...res);
      }
      messageChannel.onMessage(msgName, callBack);
      return;
    }

    // 调用主线程异步方法
    if (callType === ThreadCallType.Async) {
      log.showInfo(`set onMessageOnce ${msgName}`)
      messageChannel.onMessageOnce(msgName, (res: object[]) => {
        log.showInfo(`onMessageOnce ${msgName}`);
        fn(...res);
      });
      return;
    }
  });

  return newArg;
}

/**
 * 通过target获取需要注册给子线程的对象
 * @param target 对于静态成员来说是类的构造函数，对于实例成员是类的原型对象。
 * @returns
 */
function getTargetCallObj(target: Object): Object {
  return (typeof target === 'function') ? target : Reflect.get(target.constructor, 'instance');
}

/**
 * 通过target获取需要注册给子线程的对象名称
 * @param target 对于静态成员来说是类的构造函数，对于实例成员是类的原型对象。
 * @returns
 */
function getTargetCallObjName(target: Object): string {
  return (typeof target === 'function') ? (target.name + '_proto_') : target.constructor.name;
}

/**
 * 是否需要转换回调函数
 * @param callType 调用类型
 * @returns
 */
function isNeedTransFn(callType: ThreadCallType): boolean {
  return callType !== ThreadCallType.Sync && callType !== ThreadCallType.Msg;
}

/**
 * 是否需要转换为异步消息调用
 * @param callType 调用类型
 * @returns
 */
function isNeedDescriptorToMsg(callType: ThreadCallType): boolean {
  return callType !== ThreadCallType.Sync;
}

/**
 * 是否为非null的有效对象
 * @param callType 调用类型
 * @returns
 */
function isValidObj(obj: object): boolean {
  return typeof obj === 'object' && obj !== null;
}

/**
 * 方法在主线程直接调用
 * @param originalMethod 主线程原始方法
 * @param args 调用参数
 * @param callObj 注册给子线程的对象
 * @param uid 跨线程调用uid标识
 * @returns
 */
function callFromMainThread(originalMethod: Function, args: Object[], callObj: Object, uid: string): Object {
  try {
    return originalMethod.call(callObj, ...args, uid);
  } catch (e) {
    log.error(`originalMethod call error, from main  ${e}`);
    return undefined;
  }
}

/**
 * 监听对端执行结果，转换为promise回调
 * @param uid 跨线程调用uid标识
 * @param promise 异步调用promise
 * @param timeout 超时时间
 */
function covertResultToPromise(uid: string, promise: CustomPromise<Object>, timeout: number = 5000): void {
  messageChannel.onMessageOnce(uid, (res: Object) => {
    log.showInfo(`call msg sub recive uid: ${uid}`);
    promise.resolve(res);
    promise = undefined;
  }, timeout);

  setTimeout(() => {
    promise?.reject();
    promise = undefined;
  }, timeout);
}

/**
 * Msg类型调用，在主线程增加监听
 * @param callObjName 主线程待调用对象名称
 * @param method 待调用方法名
 * @param originalMethod 主线程原始方法
 * @param callObj 主线程待调用对象
 */
function addMainOnMsg(callObjName: string, method: string, descriptor: PropertyDescriptor, callObj: Object): void {
  log.showInfo(`subDescriptorMsg callObjName: ${callObjName} method: ${method}`);

  onMessageForMain(callObjName + method, (msgArgs: Object[]) => {
    const uid = msgArgs.pop() as string;
    log.showInfo(`onMessageForMain uid: ${uid} callObjName: ${callObjName} method: ${method}`);

    descriptor.value.call(callObj, ...msgArgs, uid);
  });
}

/**
 * Msg类型调用，主线程注册监听
 * @param name
 * @param listener
 * @returns
 */
async function onMessageForMain<T>(name: string, listener: (data: T) => void): Promise<void> {
  await messageChannel.hasInitialized;

  if (onMessageMap.has(name)) {
    return;
  }
  onMessageMap.set(name, true);
  messageChannel.onMessage(name, listener);
}

/**
 * Msg类型，主线程调用
 * @param callObjName 主线程待调用对象名称
 * @param method 待调用方法名
 * @param args 调用参数
 * @param uid 跨线程调用uid标识
 * @returns
 */
function mainDescriptorMsg(originalMethod: Function, args: Object[], callObj: Object, uid: string): void {
  log.showInfo(`mainDescriptorMsg originalMethod call uid: ${uid}`);

  try {
    log.showInfo(`mainDescriptorMsg sendMessage uid: ${uid}`);
    messageChannel.sendMessage(uid, cloneSerializableProperties(originalMethod.call(callObj, ...args)));
  } catch (e) {
    log.error(`mainDescriptorMsg call for ${uid} error:`, e);
  }
}

/**
 * Msg类型，子线程调用
 * @param callObjName 主线程待调用对象名称
 * @param method 待调用方法名
 * @param args 调用参数
 * @param uid 跨线程调用uid标识
 * @returns
 */
function subDescriptorMsg(callObjName: string, method: string, args: Object[], uid: string): CustomPromise<Object> {
  log.showInfo(`subDescriptorMsg uid: ${uid} callObjName: ${callObjName} method: ${method}`);

  let promise: CustomPromise<Object> = new CustomPromise();
  covertResultToPromise(uid, promise);
  messageChannel.sendMessage(callObjName + method, args);

  return promise;
}

/**
 * Sync类型，主线程调用
 * @param originalMethod 主线程原始方法
 * @param args 调用参数
 * @param callObj 主线程待调用对象
 * @param uid 跨线程调用uid标识
 * @returns
 */
function mainDescriptorSync(originalMethod: Function, args: Object[], callObj: Object, uid: string): Object {
  log.showInfo(`mainDescriptorSync originalMethod call uid: ${uid}`);

  try {
    return cloneSerializableProperties(originalMethod.call(callObj, ...args));
  } catch (e) {
    log.error(`mainDescriptorSync call for ${uid} error:`, e);
    return undefined;
  }
}

/**
 * Sync类型，子线程调用
 * @param callObjName 主线程待调用对象名称
 * @param method 待调用方法名
 * @param args 调用参数
 * @returns
 */
function subDescriptorSync(callObjName: string, method: string, args: Object[]): Object {
  return messageChannel.callObject(callObjName, method, ...args);
}


/**
 * Async类型，主线程调用
 * @param callObjName 主线程待调用对象名称
 * @param method 待调用方法名
 * @param args 调用参数
 * @returns
 */
function mainDescriptorAsync(originalMethod: Function, args: Object[], callObj: Object, uid: string): void {
  // 异步场景，通过promise发消息回调到子线程
  log.showInfo(`mainDescriptorAsync originalMethod call uid: ${uid}`);
  const mainPromise = originalMethod.call(callObj, ...args);
  mainPromise?.then((res: Object) => {
    log.showInfo(`mainDescriptorAsync sendMessage uid: ${uid}`);
    messageChannel.sendMessage(uid, cloneSerializableProperties(res));
  });
}

/**
 * Async类型，主线程调用
 * @param callObjName 主线程待调用对象名称
 * @param method 待调用方法名
 * @param args 调用参数
 * @param uid 跨线程调用uid标识
 * @returns
 */
function subDescriptorAsync(callObjName: string, method: string, args: Object[], uid: string): CustomPromise<Object> {
  log.showInfo(`subDescriptorAsync uid: ${uid} callObjName: ${callObjName} method: ${method}`);
  let promise: CustomPromise<Object> = new CustomPromise();
  covertResultToPromise(uid, promise);
  messageChannel.sendMessage(callObjName + method, args);

  return promise;
}

/**
 * Register类型，主线程调用
 * @param originalMethod 主线程原始方法
 * @param args 调用参数
 * @param callObj 主线程待调用对象
 * @param uid 跨线程调用uid标识
 */
function mainDescriptorRegister(originalMethod: Function, args: Object[], callObj: Object, uid: string): Object {
  log.showInfo(`mainDescriptorRegister originalMethod call uid: ${uid}`);

  // 避免子线程故障重拉时重复注册。
  if (registerMap.has(uid)) {
    return undefined;
  }
  registerMap.set(uid, args);
  try {
    return originalMethod.call(callObj, ...args);
  } catch (e) {
    log.error(`mainDescriptorRegister call for ${uid} error:`, e);
    return undefined;
  }
}

/**
 * Register类型，子线程调用
 * @param callObjName 主线程待调用对象名称
 * @param method 待调用方法名
 * @param args 调用参数
 * @param uid 跨线程调用uid标识
 * @returns
 */
function subDescriptorRegister(callObjName: string, method: string, args: Object[], uid: string): void {
  log.showInfo(`subDescriptorRegister uid: ${uid} callObjName: ${callObjName} method: ${method}`);
  registerMap.set(uid, args);

  messageChannel.sendMessage(callObjName + method, args);
}

/**
 * UnRegister类型，主线程调用
 * @param originalMethod 主线程原始方法
 * @param callObj 主线程待调用对象
 * @param uid 跨线程调用uid标识
 */
function mainDescriptorUnRegister(originalMethod: Function, callObj: Object, uid: string): Object {
  log.showInfo(`mainDescriptorUnRegister originalMethod call uid: ${uid}`);

  const registerArgs = registerMap.get(uid);
  registerMap.delete(uid);
  try {
    return originalMethod.call(callObj, ...registerArgs);
  } catch (e) {
    log.error(`mainDescriptorUnRegister call for ${uid} error:`, e);
    return undefined;
  }
}

/**
 * UnRegister类型，子线程调用
 * @param callObjName 主线程待调用对象名称
 * @param method 待调用方法名
 * @param uid 跨线程调用uid标识
 * @returns
 */
function subDescriptorUnRegister(callObjName: string, method: string, uid: string): void {
  log.showInfo(`subDescriptorUnRegister uid: ${uid} callObjName: ${callObjName} method: ${method}`);
  const registerArgs = registerMap.get(uid);
  registerMap.delete(uid);

  messageChannel.sendMessage(callObjName + method, registerArgs);
}

/**
 * 跨线程注册registerCallObject
 * @param callObjName 主线程待调用对象名称
 * @param callObj 主线程待调用对象
 */
async function registerCallObject(callObjName: string, callObj: Object): Promise<void> {
  await messageChannel.hasInitialized;

  if (callObjectMap.has(callObjName)) {
    return;
  }
  callObjectMap.set(callObjName, true);
  messageChannel.registerCallObject(callObjName, callObj);
}

/**
 * RegisterOnce清理消息监听
 * @param args 调用参数
 * @param uid 跨线程调用uid标识
 * @param index 参数索引
 */
function offMsgForRegisterOnce(args: Object, uid: string, index: number): void {
  Object.getOwnPropertyNames(args).forEach((key) => {
    if (args[key] !== FN_NAME_PLACE_HOLDER) {
      return;
    }
    const msgName = getCallBackMsgName(uid, index, key);
    messageChannel.offAllMessage(msgName);
  })
}