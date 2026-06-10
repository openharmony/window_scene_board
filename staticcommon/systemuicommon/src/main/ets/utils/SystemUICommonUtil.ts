/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import componentUtils from '@ohos.arkui.componentUtils';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import type image from '@ohos.multimedia.image';
import { ArkUIAdapter } from './ArkUIAdapter';
import { UIContext } from '@kit.ArkUI';

const TAG = 'SystemUICommonUtil';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
const DELAY_RELEASE_TIME = 10000;

interface RectResult {
  x: number;
  y: number;
  width: number;
  height: number;
}

export class TimeoutError extends Error {
  constructor(time: number) {
    super(`Timeout in ${time}ms`);
  }
}

export class SystemUICommonUtil {
  /**
   * 为方法绑定this到指定对象上，避免一些场景下this变更导致问题
   * @param obj 对象
   */
  public static bindThis(obj: Object, methods: Function[]): void {
    for (const method of methods) {
      try {
        Object.defineProperty(obj, method.name, {
          configurable: false,
          writable: false,
          value: method.bind(obj),
        });
      } catch (e) {
        log.error(`Bind this for ${method.name} error code:` + e?.code + ', message:' + e?.message);
      }
    }
  }

  /**
   * 定义属性
   * @param obj
   * @param key
   * @param descriptor
   */
  public static defineProp(obj: Object, key: string, descriptor: PropertyDescriptor): void {
    Object.defineProperty(obj, key, descriptor);
  }

  /**
   * 延迟执行
   * @param ms 延迟毫秒
   * @returns
   */
  public static sleep(ms: number): Promise<void> {
    return new Promise<void>((resolve) => setTimeout(resolve, ms));
  }

  /**
   * 安全解析JSON格式数据
   * @param jsonString 
   * @returns 
   */
  public static safeParseJson<T>(jsonString: string): T | null {
    try {
      return JSON.parse(jsonString) as T;
    } catch (e) {
      log.error('Invalid JSON string code:' + e?.code + ', message:' + e?.message);
      return null;
    }
  }

  /**
   * 函数promise防抖，同一周期内执行最后一次
   * @param fn
   * @param thisArg
   */
  public static debouncePromise<P extends Object[]>(fn: (...args: P) => void): (...args: P) => Promise<void> {
    let promise: Promise<void> | undefined;

    return async (...args: P): Promise<void> => {
      if (promise) {
        return promise;
      }
      promise = Promise.resolve()
        .then(() => {
          fn(...args);
          // then和finally之间是异步的，在fn调用之后需要立即置为undefined，
          promise = undefined;
        }, () => {
          promise = undefined;
        });
      return promise;
    };
  }

  /**
   * 防抖函数
   * @param fn 函数
   * @param delay 防抖时间
   * @returns
   */
  public static debounce<T extends (...args: Object[]) => void>(fn: T, delay: number): T {
    let timerId: number | undefined;
    const newFn = (...args: Object[]): void => {
      if (timerId !== undefined) {
        clearTimeout(timerId);
      }
      timerId = setTimeout(() => {
        timerId = undefined;
        fn(...args);
      }, delay);
    };
    return newFn as T;
  }

  /**
   * 首尾节流函数
   * @param fn 函数
   * @param delay 节流时间
   * @returns
   */
  public static throttle<T extends (...args: Object[]) => void>(fn: T, delay: number): T {
    let timerId: number | undefined;
    let startTime: number = Date.now();
    const newFn = (...args: Object[]): void => {
      clearTimeout(timerId);
      timerId = undefined;
      const currentTime: number = Date.now();
      const timeLeft: number = delay - (currentTime - startTime);

      if (timeLeft <= 0) {
        fn(...args);
        startTime = Date.now();
      } else {
        timerId = setTimeout(() => {
          fn(...args);
          timerId = undefined;
          startTime = Date.now();
        }, timeLeft);
      }
    };
    return newFn as T;
  }

  /**
   * 获取一个数字自增生成器
   * @returns
   */
  public static getIncrementGenerator(): () => number {
    let id = 0;
    return (): number => {
      if (id >= Number.MAX_SAFE_INTEGER) {
        id = 0;
      }
      return id++;
    };
  }

  /**
   * 获取组件尺寸信息，单位为vp
   * @param componentId
   * @returns
   */
  public static getRect(componentId: string, uiContext?: UIContext): RectResult {
    const result: RectResult = { x: 0, y: 0, width: 0, height: 0 };
    try {
      let rect: componentUtils.ComponentInfo;
      if (uiContext) {
        rect = uiContext.getComponentUtils().getRectangleById(componentId);
      } else {
        rect = componentUtils.getRectangleById(componentId);
      }
      result.x = ArkUIAdapter.px2vp(rect.screenOffset.x);
      result.y = ArkUIAdapter.px2vp(rect.screenOffset.y);
      result.width = ArkUIAdapter.px2vp(rect.size.width);
      result.height = ArkUIAdapter.px2vp(rect.size.height);
    } catch (e) {
      log.error(`Get rect for ${componentId} error:`, e);
    };
    return result;
  }

  /**
   * 浅拷贝一个对象
   * @param obj 原始对象
   * @returns 拷贝对象
   */
  public static shadowCopy<T>(obj: T): T {
    if (typeof obj !== 'object' || obj.constructor === Object) {
      return obj;
    }
    const newObj = new (obj.constructor as typeof Object)();
    for (const key of Object.keys(obj)) {
      const value = Reflect.get(obj, key);
      if (typeof value === 'function') {
        continue;
      }
      Reflect.set(newObj, key, value);
    }
    return newObj as T;
  }

  /**
   * 异步任务设置超时时间，超时后reject
   * @param promise 异步任务
   * @param time 超时时间
   * @returns 返回异步任务执行结果，超时reject
   */
  public static async timeout<T>(promise: Promise<T>, time: number): Promise<T> {
    let timer: number | undefined;
    const timeoutPromise = new Promise<void>((resolve, reject) => {
      timer = setTimeout(() => {
        reject(new TimeoutError(time));
      }, time);
    });
    const res = await Promise.race([promise, timeoutPromise]);
    clearTimeout(timer);
    return res as Promise<T>;
  }

  /**
   * 释放图片资源，如果新旧图片资源相同则无需释放
   *
   * @param name 图片名称
   * @param img 即需要释放的图片资源
   * @param usingImg 新图片资源
   */
  public static async releaseImage(img?: image.PixelMap, usingImg?: image.PixelMap): Promise<void> {
    if (!img || img === usingImg) {
      return;
    }
    const name = SystemUICommonUtil.getPixelMapName(img);
    try {
      if (name.includes('media_')) {
        await SystemUICommonUtil.sleep(DELAY_RELEASE_TIME);
      }
      await img.release();
      log.showInfo(`Release image ${name} success`);
    } catch (e) {
      log.error(`Release image ${name} error:`, e);
    }
  }

  /**
   * 设置图片名称
   */
  public static setPixelMapName(pixelMap: image.PixelMap | undefined, name: string): void {
    if (pixelMap && pixelMap instanceof Object) {
      Reflect.set(pixelMap, 'name', name);
      try {
        pixelMap.setMemoryNameSync(`S_${name}`);
      } catch (e) {
        log.warn(`set memoryNameSync to ${name} failed`);
      }
    }
  }

  public static getPixelMapName(pixelMap: image.PixelMap): string {
    if (pixelMap && pixelMap instanceof Object) {
      return Reflect.get(pixelMap, 'name') ?? '';
    }
    return '';
  }

  /**
   * 合并对象，合并方式为浅拷贝
   * @param target
   * @param source
   * @returns
   */
  public static assign(target: Record<string, Object>, source: Record<string, Object>): Record<string, Object> {
    if (!source) {
      return target;
    }
    for (const key of Object.keys(source)) {
      target[key] = source[key];
    }
    return target;
  }
}