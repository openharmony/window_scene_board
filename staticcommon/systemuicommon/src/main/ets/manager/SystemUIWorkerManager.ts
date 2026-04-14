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

import { worker } from '@kit.ArkTS';
import { messageChannel } from '../messageChannel/MessageChannel';
import { ThreadSync } from '../messageChannel/ThreadSync';
import { wantAgent } from '@kit.AbilityKit';
import { NotificationBridge } from '../bridge/NotificationBridge';
import { EventEmitter } from '../utils/EventEmitter';
import { LogDomain, LogHelper, Trace } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { SystemUICommonUtil } from '../utils/SystemUICommonUtil';
import { SystemUICcmConfig } from '../utils/SystemUICcmConfig';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'SystemUIWorkerManager');

const WORKER_BLOCK_TIMEOUT = 10 * 1000;

interface SystemUIDcEvent {
  workerErr: {
    errType: SysUIWorkerErr
  },
  workerReady: {
    isReady: boolean
  }
}

/**
 * worker异常类型
 */
export enum SysUIWorkerErr {
  CRASH = 1,
  FREEZE = 2,
  EXIT = 3,
}

/**
 * SystemUI worker线程管理
 */
class SystemUIWorkerManager {
  /**
   * worker实例
   */
  public workerThread?: worker.ThreadWorker;
  /**
   * worker的tid
   */
  public tid?: number;
  /**
   * worker异常回调
   */
  public readonly emitter = new EventEmitter<SystemUIDcEvent>();
  /**
   * worker文件路径
   */
  private workerFilePath?: string;
  /**
   * 是否启动SystemUI worker缓存结果
   */
  private isEnabledResult?: boolean;
  /**
   * 子线程freeze检测定时器
   */
  private watchDogTimer = null;

  /**
   * 是否启用SystemUI Worker
   * @returns
   */
  public isEnabled(): boolean {
    if (this.isEnabledResult !== undefined) {
      return this.isEnabledResult;
    }
    try {
      this.isEnabledResult = SystemUICcmConfig.instance.isEnabledWorker;
    } catch (e) {
      log.error('Get persist.systemui.worker error:', e);
      this.isEnabledResult = false;
    }
    return this.isEnabledResult;
  }

  /**
   * 初始化
   */
  public async init(workerFilePath?: string): Promise<void> {
    log.showInfo(`Init systemUI worker manager`);

    await this.clear();

    if (workerFilePath) {
      this.workerFilePath = workerFilePath;
    }

    if (!this.isEnabled()) {
      messageChannel.init(messageChannel.getDefaultController());
      return;
    }

    // 创建worker
    await this.createWorker();

    // 准备worker场景的一些全局配置
    this.prepareWorkerEnv();

    messageChannel.init(this.workerThread);

    // 监听子线程初始化完成
    messageChannel.onMessage('init', (tid: number) => {
      this.tid = tid;
      ThreadSync.init();
      this.emitter.emit('workerReady', { isReady: true });

      log.showInfo(`Worker init end. tid: ${this.tid}`);
    });

    // 发送context触发子线程init
    messageChannel.sendMessage('init', GlobalContext.getContext());

    // 初始化主线程bridge
    NotificationBridge.get().init();
  }

  /**
   * 创建worker
   */
  private async createWorker(): Promise<void> {
    if (this.workerThread) {
      log.showWarn('SystemuiWorker is created');
      return;
    }
    Trace.start('CreateSystemUIWorker');

    // 初始化worker，失败重试3次（间隔1s、2s、4s指数递增）
    let retryTimes = 0;
    while (!this.workerThread && retryTimes < 3) {
      try {
        this.workerThread = new worker.ThreadWorker(this.workerFilePath, { name: 'SystemuiWorker' });
        this.workerThread.onAllErrors = (err): void => {
          log.error('SystemuiWorker onerror:', err);
        };
        this.workerThread.onexit = (code): void => {
          log.error('SystemuiWorker onexit:', code);
          this.workerThread = undefined;

          this.handleWorkerError(SysUIWorkerErr.EXIT);
        };

        log.showInfo('SystemuiWorker created');
      } catch (e) {
        log.error(`SystemuiWorker create error: ${e}, retryTimes: ${retryTimes}`);
        await SystemUICommonUtil.sleep(1000 * Math.pow(2, retryTimes));
        retryTimes++;
        await this.clear();
      }
    }

    Trace.end('CreateSystemUIWorker');
  }

  /**
   * 初始化前的清理动作，确保子线程重拉时init方法可重入
   */
  private async clear(): Promise<void> {
    clearTimeout(this.watchDogTimer);
    this.tid = undefined;

    // 退出子线程。这里有两种场景：
    // 1、在timeout时限内退出子线程成功，则重新拉起子线程。
    // 2、子线程死锁无法退出，触发进程重启。
    if (this.workerThread) {
      try {
        log.showInfo(`terminate systemUI worker`);
        this.workerThread.terminate();
      } catch (e) {
        log.error('terminate worker error:', e);
      }
    }

    // 等待子线程退出，任务较多的情况下时间较长。
    let retryTimes = 0;
    while (this.workerThread && retryTimes < 30) {
      await SystemUICommonUtil.sleep(1000);
      retryTimes++;
    }

    // 线程退出超时，重启进程
    if (this.workerThread) {
      setTimeout(() => {
        // 新起一个宏任务抛错，避免被catch
        throw new Error('systemUI worker terminate timeout');
      })
      // 阻塞后续执行，等待进程重启
      await SystemUICommonUtil.sleep(5000);
    }
  }

  /**
   * 初始化子线程freeze检测
   */
  public async initWatchDogTimer(): Promise<void> {
    log.showInfo(`initWatchDogTimer`);

    messageChannel.onMessage('watchDog', this.startWatchDog);
    this.startWatchDog();
  }

  /**
   * freeze超时回调
   */
  private timeoutFn = (): void => {
    log.warn(`System ui worker block ${WORKER_BLOCK_TIMEOUT} ms`);
  };

  /**
   * 开始定时watchDog
   */
  private startWatchDog = (): void => {
    if (this.watchDogTimer) {
      clearTimeout(this.watchDogTimer);
    }
    this.watchDogTimer = setTimeout(this.timeoutFn, WORKER_BLOCK_TIMEOUT);
  };

  /**
   * 发送worker异常事件
   * @param errType
   */
  private async handleWorkerError(errType: SysUIWorkerErr): Promise<void> {
    log.error(`Emit systemui worker error, type: ${errType}`);
    this.emitter.emit('workerErr', { errType });

    // 等待DC组件下树
    await SystemUICommonUtil.sleep(100);

    // 重新拉起worker，重新建立跨线程通信
    systemUIWorkerManager.init();
  };

  /**
   * 准备worker场景的一些全局配置
   */
  private prepareWorkerEnv(): void {
    try {
      // 启用wantagent跨线程sendable能力
      const setWantAgentMultithreadingFn = Reflect.get(wantAgent, 'setWantAgentMultithreading');
      if (typeof setWantAgentMultithreadingFn === 'function') {
        setWantAgentMultithreadingFn.call(wantAgent, true);
      } else {
        log.error('setWantAgentMultithreading is not function');
      }
    } catch (e) {
      log.error('prepareWorkerEnv error:', e);
    }
  }
}

export const systemUIWorkerManager = new SystemUIWorkerManager();