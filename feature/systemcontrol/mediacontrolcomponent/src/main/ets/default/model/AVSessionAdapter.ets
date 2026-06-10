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
import AVSessionManager from '@ohos.multimedia.avsession';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { AVSessionItem } from './AVSessionItem';
import { avSession } from '@kit.AVSessionKit';
import { MediaEventFactory } from '../EventBus/MediaEventFactory';
import { MediaEventManager, MediaEventType } from '../EventBus/MediaEventManager';
import CommonUtils from '../Util/CommonUtils';
import CommonEventManager from '@ohos.commonEventManager';
import CommunicationUtil from '../Util/CommunicationUtil';

const TAG = 'AVSessionAdapter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

/*
  AVSession适配器
  进程内所有与AVSession进程的交互都可以由此适配器负责与管理
  此适配器内部会与AVSession进程保持通信并承诺数据一致
  与此适配器的交互（监听与查询）等价于与AVSession进程交互
  目的是减少与AVSession进程交互造成的额外跨进程开销，并减少多处数据储存的内存消耗
 */
export class AVSessionAdapter {
  private static adapter: AVSessionAdapter;

  private avSessionItemMap: Map<string, AVSessionItem> = new Map<string, AVSessionItem>();

  private commonEventSubscriber: CommonEventManager.CommonEventSubscriber | null = null;

  private static createNewInstance(): AVSessionAdapter {
    let adapter = new AVSessionAdapter();
    adapter.init();
    return adapter;
  }

  /*
    获取AVSessionAdapter单例
   */
  public static getInstance(): AVSessionAdapter {
    if (AVSessionAdapter.adapter) {
      return AVSessionAdapter.adapter;
    } else {
      log.showError(`getInstance fail, create new one`);
      AVSessionAdapter.adapter = AVSessionAdapter.createNewInstance();
      return AVSessionAdapter.adapter;
    }
  }

  private init() {
    this.initSessions();
    this.initDevices();
    this.initCommonEventCallback();
  }

  private initSessions() {
    AVSessionManager.on('sessionCreate', this.sessionCreateCallback);
    AVSessionManager.on('sessionDestroy', this.sessionDestroyCallback);
    AVSessionManager.on('topSessionChange', this.topSessionChangeCallback);
  }

  private initDevices() {

  }

  private initCommonEventCallback() {
    CommonEventManager.createSubscriber({ 'events': ['usual.event.AVSESSION_START'] },
      (error, commonEventSubscriber) => {
      if (error) {
        log.showError(`create commonEvent subscriber failed. Code: ${error.code}, message: ${error.message}`);
        return;
      }
      // 订阅通用事件
      this.commonEventSubscriber = commonEventSubscriber;
      try {
        CommonEventManager.subscribe(this.commonEventSubscriber, (err, data) => {
          CommunicationUtil.doLocalEventNotify('sessionServiceDie', 'clear');
          this.sessionServiceDieCallback();
        });
      } catch (err) {
        log.showError(`common event subscribe failed. Code: ${err.code}, message: ${err.message}`);
      }
    });
  }

  private sessionCreateCallback: (descriptor: avSession.AVSessionDescriptor) => void =
    async (descriptor: avSession.AVSessionDescriptor) => {
      MediaEventManager.notifyEvent(MediaEventType.SESSION_CREATE,
        MediaEventFactory.createSessionCreateEvent(descriptor));
      let maskSessionId: string = descriptor?.sessionId;
      maskSessionId = maskSessionId?.length < 10 ? '' : (maskSessionId?.substr(0, 5) +
        '**' + maskSessionId?.substr(maskSessionId?.length - 5));
      if (this.avSessionItemMap.has(descriptor.sessionId)) {
        log.showError(`session create already exist ${maskSessionId}`);
      } else {
        this.avSessionItemMap.set(descriptor.sessionId, await AVSessionItem.createAVSessionItem(descriptor));
        log.showInfo(`session create ${maskSessionId} current size ${this.avSessionItemMap.size}`);
      }
    };

  private sessionDestroyCallback: (descriptor: avSession.AVSessionDescriptor) => void =
    async (descriptor: avSession.AVSessionDescriptor) => {
      MediaEventManager.notifyEvent(MediaEventType.SESSION_DESTROY,
        MediaEventFactory.createSessionDestroyEvent(descriptor));
      let tempSessionId: string = descriptor?.sessionId;
      tempSessionId = tempSessionId?.length < 10 ? '' : (tempSessionId?.substr(0, 5) +
        '**' + tempSessionId?.substr(tempSessionId?.length - 5));
      if (this.avSessionItemMap.has(descriptor.sessionId)) {
        this.avSessionItemMap.get(descriptor.sessionId)?.release();
        this.avSessionItemMap.delete(descriptor.sessionId);
        log.showInfo(`session destroy ${tempSessionId} current size ${this.avSessionItemMap.size}`);
      } else {
        log.showError(`session destroy not found ${tempSessionId}`);
      }
    };

  private topSessionChangeCallback: (descriptor: avSession.AVSessionDescriptor) => void =
    async (descriptor: avSession.AVSessionDescriptor) => {
      log.showInfo(`topSessionChange sessionId:${descriptor?.sessionId?.length < 10 ? '' :
        (descriptor?.sessionId?.substr(0, 5) + '**' +
        descriptor?.sessionId?.substr(descriptor?.sessionId?.length - 5))}.`);
      // 自恢复
      if (!this.avSessionItemMap.has(descriptor.sessionId)) {
        log.showInfo(`topsession not found, recover ${CommonUtils.getMaskStr(descriptor.sessionId)}`);
        this.sessionCreateCallback(descriptor);
      }
      MediaEventManager.notifyEvent(MediaEventType.TOP_SESSION_CHANGE,
        MediaEventFactory.createTopSessionChangeEvent(descriptor));
    };

  private sessionServiceDieCallback: () => void =
    async () => {
      log.showInfo(`sessionServiceDie`);
      try {
        AVSessionManager.off('topSessionChange', this.topSessionChangeCallback);
      } catch (err) {
        log.error('AVSessionManager off topSessionChange error');
      }
      try {
        AVSessionManager.off('sessionCreate', this.sessionCreateCallback);
      } catch (err) {
        log.error('AVSessionManager off sessionCreate error');
      }
      try {
        AVSessionManager.off('sessionDestroy', this.sessionDestroyCallback);
      } catch (err) {
        log.error('AVSessionManager off sessionDestroy error');
      }
      this.avSessionItemMap.forEach((item, sessionId) => {
        item.release();
      });
      this.avSessionItemMap.clear();
      AVSessionManager.on('sessionCreate', this.sessionCreateCallback);
      AVSessionManager.on('sessionDestroy', this.sessionDestroyCallback);
      AVSessionManager.on('topSessionChange', this.topSessionChangeCallback);
    };

  private async refreshAllSession() {
    let descriptors: AVSessionManager.AVSessionDescriptor[] = [];
    try {
      descriptors = await AVSessionManager.getAllSessionDescriptors();
    } catch (err) {
      log.error(`refreshAllSession err ${JSON.stringify(err)}`);
    }
    for (let descriptor of descriptors) {
      this.sessionCreateCallback(descriptor);
    }
  }

  /*
    通过sessionId获取指定AVSessionItem，如果找不到会返回undefined
   */
  public getAVSessionItem(sessionId: string): AVSessionItem | undefined {
    return this.avSessionItemMap.get(sessionId);
  }
}