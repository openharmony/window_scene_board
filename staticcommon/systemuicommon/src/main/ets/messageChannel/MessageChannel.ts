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

import { SystemuiConstants } from '../constants/SystemuiConstants';
import { MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import hiTraceMeter from '@ohos.hiTraceMeter';
import { SystemUICommonUtil } from '../utils/SystemUICommonUtil';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CustomPromise } from '@ohos/frameworkwrapper/src/main/ets/base/CustomPromise';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'MessageChannel');

type Fn = (...args: Object[]) => Object;
type Listener = (data: Object) => void;

export interface MessageController {
  onmessage?: (ev: MessageEvents) => void;
  onmessageerror?: (ev: MessageEvents) => void;
  postMessageWithSharedSendable: (message: Object) => void;
}

interface Message {
  name: string;
  data: Object;
}

interface InvokeMessageRequest {
  /**
   * 本次调用的ID序号
   */
  id: number;

  /**
   * 函数名称
   */
  callerName: string;

  /**
   * 函数参数
   */
  args: Object[];
}

interface InvokeMessageResponse {
  /**
   * 本次调用的ID序号
   */
  id: number;

  /**
   * 函数名称
   */
  callerName: string;

  /**
   * 调用是否成功
   */
  success: boolean;

  /**
   * 调用结果
   */
  result?: Object;
}

enum MessageTraceId {
  MESSAGE = -1000,
}

const INVOKE_REQUEST_MESSAGE_ID = '_INVOKE_REQUEST_';
const INVOKE_RESPONSE_MESSAGE_ID = '_INVOKE_RESPONSE_';
const getRequestId = SystemUICommonUtil.getIncrementGenerator();

/**
 * 线程间通信基类
 */
class MessageChannel {
  /**
   * 跨线程对象调用集
   */
  protected static callObjectMap: Map<string, Object> = new Map();
  /**
   * 消息控制器
   */
  protected controller?: MessageController;
  /**
   * 保存跨线程调用的方法集合
   */
  protected callerMap: Map<string, Fn> = new Map();
  /**
   * 跨线程调用等待集合
   */
  protected invokePromiseMap: Map<number, CustomPromise<Object>> = new Map();
  /**
   * 保存事件监听器
   */
  protected listenerMap: Map<string, Set<Listener>> = new Map();
  /**
   * MessageChannel是否已初始化完成
   */
  public hasInitialized = new CustomPromise<void>();

  /**
   * worker的tid
   */
  public tid?: number;

  /**
   * 消息通道初始化
   * @param controller 线程通信通道
   */
  public init(controller: MessageController): void {
    this.controller = controller;
    controller.onmessage = this.handleMessage;
    controller.onmessageerror = (err): void => {
      log.error('On message error:', err);
    };

    // 注册跨线程远程调用
    MessageChannel.callObjectMap.forEach(async (obj, name) => {
      await this.registerCallObject(name, obj);
    });

    this.hasInitialized.resolve();
  }

  /**
   * 获取默认消息控制器，用于同线程间通信时转发数据
   * @returns
   */
  public getDefaultController(): MessageController {
    return {
      postMessageWithSharedSendable: (data: Message) => this.handleMessage({
        type: '',
        timeStamp: 0,
        data,
      }),
    };
  }

  /**
   * 注册跨线程调用方法
   * @param callerName 函数名
   * @param fn 函数实现
   */
  public registerCaller(callerName: string, fn: Fn): void {
    this.callerMap.set(callerName, fn);
  }

  /**
   * 取消注册一个调用方法
   * @param callerName 方法名
   */
  public unregisterCaller(callerName: string): void {
    this.callerMap.delete(callerName);
  }

  /**
   * 跨线程调用方法，等待结果返回
   * @param callerName 方法名
   * @param args 方法参数
   * @returns 方法返回结果
   */
  public async call(callerName: string, ...args: Object[]): Promise<Object> {
    const request: InvokeMessageRequest = {
      id: getRequestId(),
      callerName: callerName as string,
      args
    };
    this.sendMessage(INVOKE_REQUEST_MESSAGE_ID, request);
    const promise = new CustomPromise<Object>();
    this.invokePromiseMap.set(request.id, promise);
    return promise;
  }

  /**
   * 向对端发送消息，不需要等待结果
   * @param name 消息名称
   * @param data 消息携带的数据
   */
  public sendMessage<T>(name: string, data: T): void {
    const message: Message = { name, data };
    this.postMessage(message);
  }

  /**
   * 监听对端发送过来消息
   * @param name 消息名称
   * @param data 消息携带的数据
   * @param single 仅支持一个监听回调，避免重复注册
   */
  public onMessage<T>(name: string, listener: (data: T) => void, single = true): void {
    if (single) {
      this.offAllMessage(name);
    }

    if (!this.listenerMap.has(name)) {
      this.listenerMap.set(name, new Set());
    }
    this.listenerMap.get(name)!.add(listener);
  }

  /**
   * 单次监听对端发送过来消息，用于跨线程回调函数的场景
   * @param name 消息名称
   * @param listener 回调函数
   * @param timeout 超时时间，默认10s
   */
  public onMessageOnce<T>(name: string, listener: (data: T) => void, timeout = 10000): void {
    let timer: number | null = null;

    const listenerOnce = (data: T): void => {
      listener(data);
      this.offMessage(name, listenerOnce);

      clearTimeout(timer);
    };
    this.onMessage(name, listenerOnce, false);

    timer = setTimeout(() => {
      log.error(`On message once timeout: ${name}`);
      this.offMessage(name, listenerOnce);
    }, timeout);
  }

  /**
   * 取消监听对端消息
   * @param name
   * @param listener
   */
  public offMessage(name: string, listener: (data: Object) => void): void {
    if (!this.listenerMap.has(name)) {
      return;
    }
    this.listenerMap.get(name)!.delete(listener);
  }

  /**
   * 取消监听对端消息
   * @param name
   * @param listener
   */
  public offAllMessage(name: string): void {
    if (!this.listenerMap.has(name)) {
      return;
    }
    this.listenerMap.get(name)!.clear();
  }

  /**
   * 处理消息
   */
  private handleMessage = (event: MessageEvents): void => {
    try {
      const message = event?.data as Message;
      if (!message?.name) {
        log.error(`Invalid message:`, event);
        return;
      }
      hiTraceMeter.finishTrace(SystemuiConstants.TRACE_THREAD_MESSAGE + message.name, MessageTraceId.MESSAGE);
      log.showDebug(`Receive message: ${message.name}`);
      if (message.name === INVOKE_REQUEST_MESSAGE_ID) {
        this.invokeCaller(message.data as InvokeMessageRequest);
      } else if (message.name === INVOKE_RESPONSE_MESSAGE_ID) {
        this.returnCaller(message.data as InvokeMessageResponse);
      } else {
        this.dispatchMessage(message);
      }
    } catch (e) {
      log.error('On message handle error:', e);
    }
  };

  /**
   * 调用发送消息的方法
   */
  private postMessage(message: Message): void {
    if (!this.controller) {
      return;
    }
    hiTraceMeter.startTrace(SystemuiConstants.TRACE_THREAD_MESSAGE + message.name, MessageTraceId.MESSAGE);
    log.showDebug(`Post message: ${message.name}`);
    try {
      this.controller.postMessageWithSharedSendable(message);
    } catch (e) {
      log.error(`Post message for ${message.name} error:`, e);
    }
  }

  /**
   * 分发消息
   * @param messageId
   * @param data
   */
  private dispatchMessage(message: Message): void {
    const listeners = this.listenerMap.get(message.name);
    if (listeners) {
      log.showDebug(`Dispatch message ${message.name}, listener size: ${listeners.size}`);
      listeners.forEach((listener) => {
        try {
          listener(message.data);
        } catch (e) {
          log.error(`Diapatch ui message error:`, e);
        }
      });
    } else {
      log.warn(`Not found listeners for message ${message.name}`);
    }
  }

  /**
   * 调用caller
   * @param message
   */
  private async invokeCaller(request: InvokeMessageRequest): Promise<void> {
    const response: InvokeMessageResponse = { id: request.id, callerName: request.callerName, success: false };
    const key = `${request.callerName}_${request.id}`;

    try {
      const fn = this.callerMap.get(request.callerName) as (...args: Object[]) => Promise<Object>;
      if (!fn) {
        throw new Error(`Caller ${request.callerName} is not registered.`);
      }
      response.result = await fn(...request.args) as Object;
      response.success = true;
    } catch (e) {
      log.error(`Invoke caller for ${key} error:`, e);
      response.success = false;
      response.result = e;
    }
    this.postMessage({ name: INVOKE_RESPONSE_MESSAGE_ID, data: response });
  }

  /**
   * 返回caller结果
   * @param response
   */
  private returnCaller(response: InvokeMessageResponse): void {
    const promise = this.invokePromiseMap.get(response.id);
    if (!promise) {
      log.error(`Not found invoke promise for ${response.callerName}_${response.id}`);
      return;
    }
    if (response.success) {
      promise.resolve(response.result);
    } else {
      promise.reject(response.result as Error);
    }
    this.invokePromiseMap.delete(response.id);
  }

  /**
   * 主线程向子线程注册
   * @param name
   * @param obj
   */
  public async registerCallObject(name: string, obj: Object): Promise<void> {
    // 通过装饰器注册时，需要等待MessageChannel初始化完成
    await this.hasInitialized;

    if (this.controller instanceof worker.ThreadWorker) {
      this.controller.registerGlobalCallObject(name, obj);
    }

    // worker场景也需要保存map，子线程重启时触发重新注册
    MessageChannel.callObjectMap.set(name, obj);
  }

  /**
   * 子线程调用主线程方法
   * @param name 对象名称
   * @param method
   * @param args 参数集合
   */
  public callObject(name: string, method: string, ...args: Object[]): Object {
    try {
      const controller = this.controller as ThreadWorkerGlobalScope;
      if (controller?.callGlobalCallObjectMethod) {
        log.info(`Call object method ${name}_${method} begin:`, args);
        const time = Date.now();
        const result = controller.callGlobalCallObjectMethod(name, method, 1000, ...args);
        const diffTime = Date.now() - time;
        if (diffTime < 50) {
          log.showInfo(`Call object method ${name}_${method} end. time: ${diffTime}`);
        } else {
          log.showWarn(`Call object method ${name}_${method} end. use long time: ${diffTime}`);
        }
        return result;
      } else {
        const object = MessageChannel.callObjectMap.get(name);
        if (!object) {
          log.error(`Not found call object for ${name}`);
          return undefined;
        }
        const fn: Function = object[method];
        if (!object) {
          log.error(`Not found call method for ${name}_${method}`);
          return undefined;
        }
        return fn.call(object, ...args);
      }
    } catch (e) {
      log.error(`Call object method ${name}_${method} error:`, e);
      return undefined;
    }
  }
}

export const messageChannel = new MessageChannel();

/**
 *
 * 将原始对象克隆生成一个可以序列化的对象，用于postMessage传递。
 * @param src 原始对象
 * @param target 克隆生成的对象
 * @param excludeFn 指定过滤排除部分key不做序列化同步
 * @returns
 */
export function cloneSerializableProperties<T>(src: T, target?: Record<string, Object> | T | undefined[],
  excludeFn?: (key: string, value: Object) => boolean): T {
  if (typeof src !== 'object' || src === null) {
    return src;
  }

  if (Array.isArray(src)) {
    target = target || [];
  } else {
    target = target || {};
  }

  const keys = Object.getOwnPropertyNames(src);
  keys.forEach((key) => {
    // 指定了过滤排除部分key
    if (excludeFn && excludeFn(key, src[key])) {
      return;
    }

    // 函数类型不支持序列化
    if (typeof src[key] === 'function') {
      return;
    }

    // 非object类型，可以直接拷贝
    if (typeof src[key] !== 'object' || src[key] === null) {
      target[key] = src[key];
      return;
    }

    // wantAgent和pixelMap场景，arkUI进行了Sendable包装，可以直接拷贝引用
    if (isSendableObj<T>(key, src)) {
      target[key] = src[key];
      return;
    }

    // 其他对象类型，递归拷贝
    target[key] = Array.isArray(src[key]) ? [] : {};
    cloneSerializableProperties(src[key], target[key]);
  });

  return target as T;
}

/**
 * 是否为Sendable类型的对象，当前支持wantAgent和pixelMap
 * @param key 字段
 * @param obj 待处理的原始对象
 * @returns
 */
function isSendableObj<T>(key: string, obj: T): boolean {
  // wantAgent  可以优化一下判断方式？
  if (key === 'wantAgent' || key === 'extensionWantAgent' || key === 'removalWantAgent') {
    return true;
  }

  // pixelMap
  if (typeof obj[key]?.getPixelBytesNumber === 'function') {
    return true;
  }

  return false;
}