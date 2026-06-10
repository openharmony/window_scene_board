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
import { displaySync } from '@kit.ArkGraphics2D';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'FrameUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const HEXADECIMAL_VALUE = 36;

/** 获取uuid */
function getUUID(): string {
  let id = Date.now().toString(HEXADECIMAL_VALUE);
  id += Math.random().toString(HEXADECIMAL_VALUE).substring(2);
  id += Math.random().toString(HEXADECIMAL_VALUE).substring(2);
  return id;
}

/** 帧刷新监听器 */
export class FrameListener {
  private callbackMap: Map<string, FrameListenerCallback> = new Map();
  private mDisplaySync?: displaySync.DisplaySync;
  public frameCount: number = 0;

  /**
   * 获取单例
   * @returns
   */
  public static getInstance(): FrameListener {
    if (!globalThis.FrameListener) {
      globalThis.FrameListener = new FrameListener();
    }
    return globalThis.FrameListener;
  }

  /**
   * 注册回调
   * @param callback 每帧回调
   * @returns 该回调的标识符，用于注销
   */
  public register(callback: FrameListenerCallback): string {
    const unique: string = getUUID();
    log.showInfo(`unique(${unique}) register, callBy: ${this.getStack()}`);
    this.callbackMap.set(unique, callback);
    this.start();
    return unique;
  }

  /**
   * 注销回调
   * @param unique 注册时返回的标识符
   * @returns
   */
  public unregister(unique: string): boolean {
    const stack = this.getStack();
    let res: boolean = false;
    if (this.callbackMap.has(unique)) {
      res = this.callbackMap.delete(unique);
      log.showInfo(`unique(${unique}) unregister ${res}, callBy: ${stack}`);
      if (this.callbackMap.size === 0) {
        this.end();
      }
    } else {
      log.showInfo(`unique(${unique}) does not exist or has been deregistered, callBy: ${stack}`);
    }
    return res;
  }

  /** 开始监听帧事件 */
  private start(): void {
    if (!this.mDisplaySync) {
      log.showInfo('frameListener start');
      this.mDisplaySync = displaySync.create();
      this.mDisplaySync.setExpectedFrameRateRange({
        min: 0,
        max: 144,
        expected: 120
      });
      this.mDisplaySync.start();
      this.frameCount = 0;
      this.mDisplaySync.on('frame', (info: displaySync.IntervalInfo) => {
        this.frameCount++;
        this.onFrame(info.timestamp, info.targetTimestamp);
      });
    }
  }

  /** 停止监听 */
  private end(): void {
    if (this.mDisplaySync) {
      log.showInfo('frameListener end');
      this.mDisplaySync.off('frame');
      this.mDisplaySync.stop();
      this.mDisplaySync = undefined;
    }
  }

  private async onFrame(curTime: number, nextTime: number): Promise<void> {
    this.callbackMap.forEach(async callback => callback(curTime, nextTime));
  }

  private getStack(): string {
    try {
      const err = new Error();
      const source = err.stack?.slice(1, -1).split('\n').map(item => item.split('/').pop()).filter(x => x).slice(0, 3);
      return source?.join(' -> ');
    } catch (error) {
      return `getCallerStack error: ${error?.code}`;
    }
  }
}

export interface FrameListenerCallback {
  (curTimeStamp: number, nextTimeStamp: number): void
}

interface FrameSetTimeoutItem {
  callback: () => void,
  delay: number,
  startTime: number,
}

/**
 * 按帧来监听setTimeout
 */
export class FrameSetTimeout {
  private eventMap: Map<string, FrameSetTimeoutItem> = new Map();
  private frameListener: string;

  /**
   * 开启一个计时
   * @param callback 时间到之后的回调
   * @param delay 计时时间
   * @returns 用来取消计时的Id
   */
  public start(callback: () => void, delay: number): string {
    const timerCode = getUUID();
    log.showInfo(`start FrameSetTimeout timerCode:${timerCode} delay:${delay}`);
    this.eventMap.set(timerCode, {
      callback: callback,
      delay: delay,
      startTime: Date.now()
    });
    if (!this.frameListener) {
      this.frameListener = FrameListener.getInstance().register(() => {
        this.onFrame();
      });
    }
    return timerCode;
  }

  /**
   * 清理一个计时
   * @param timerCode 开启时返回的id
   * @returns 清理成功返回true, 当前不存在返回false
   */
  public clear(timerCode: string): boolean {
    log.showInfo(`clear FrameSetTimeout timerCode:${timerCode}`);
    if (this.eventMap.has(timerCode)) {
      const deleteRes = this.eventMap.delete(timerCode);
      this.releaseFrameListener();
      return deleteRes;
    } else {
      return false;
    }
  }

  private onFrame(): void {
    const now = Date.now();
    let isDeleted = false;
    this.eventMap.forEach((item: FrameSetTimeoutItem, timerCode: string) => {
      if ((now - item.startTime) >= item.delay) {
        log.showInfo(`end FrameSetTimeout timerCode:${timerCode}`);
        item.callback();
        this.eventMap.delete(timerCode);
        isDeleted = true;
      }
    });
    if (isDeleted) {
      this.releaseFrameListener();
    }
  }

  private releaseFrameListener(): void {
    if (this.eventMap.size === 0) {
      FrameListener.getInstance().unregister(this.frameListener);
      this.frameListener = undefined;
    }
  }
}