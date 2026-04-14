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
import hiSysEvent from '@ohos.hiSysEvent';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';

const TAG = 'HiSysEventUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

const MEDIA_CONTROL_DOMAIN = 'MEDIA_CONTROLLER';
const MEDIACONTROL_UE = 'MEDIACONTROL_UE';

export class HiSysEvent {

  public static eventMap: Map<EventType, EventParam> = new Map();

  public static getEventParam(eventType: EventType): EventParam {
    let eventParam: EventParam | undefined = HiSysEvent.eventMap.get(eventType);
    if (!eventParam) {
      eventParam = new EventParam(eventType);
      HiSysEvent.eventMap.set(eventType, eventParam);
    }
    return eventParam;
  }

  public static clear() {
    HiSysEvent.eventMap.clear();
  }
}

export enum EventType {
  HISTORY_AVQUEUE_INFO = 'HISTORY_AVQUEUE_INFO',
  HISTORY_AVQUEUE_PLAY = 'HISTORY_AVQUEUE_PLAY',
  JUMP_APP = 'JUMP_APP',
  JUMP_TIPS = 'JUMP_TIPS',
  LOCAL_DEVICE_ADJUST_VOLUME = 'LOCAL_ADJUST_VOLUME',
  LOCAL_DEVICE_FASTFORWARD = 'LOCAL_FASTFORWARD',
  LOCAL_FAVORITE = 'LOCAL_FAVORITE',
  LOCAL_DEVICE_LOOPMODE = 'LOCAL_LOOPMODE',
  LOCAL_DEVICE_NEXT = 'LOCAL_NEXT',
  LOCAL_DEVICE_PAUSE = 'LOCAL_PAUSE',
  LOCAL_DEVICE_PLAY = 'LOCAL_PLAY',
  LOCAL_DEVICE_PREVIOUS = 'LOCAL_PREVIOUS',
  LOCAL_DEVICE_REWIND = 'LOCAL_REWIND',
  LOCAL_DEVICE_SEEK = 'LOCAL_SEEK',
  MEDIA_CONTROL_ACTIVE = 'MEDIA_CONTROL_ACTIVE',
  MEDIA_ROUTER_DEVICE_FOUND = 'MEDIA_ROUTER_DEVICE_FOUND',
  SHOW_DEVICE_LIST = 'SHOW_DEVICE_LIST',
  SWITCH_DEVICE = 'SWITCH_DEVICE',
  SWITCH_DEVICE_FAILED = 'SWITCH_DEVICE_FAIL',
  JUMP_APP_FAIL = 'JUMP_APP_FAIL',
  LOCAL_CONTROL_FAILED = 'LOCAL_CONTROL_FAIL',
  MEDIA_CONTROL_CAST_BEHAVIOR = 'MEDIA_CONTROL_CAST_BEHAVIOR',
  MEDIA_ROUTER_UNEXPECTED_BEHAVIOR = 'MEDIA_ROUTER_UNEXPECTED_BEHAVIOR',
  AVQUEUE_SHOW_STATE = 'AVQUEUE_SHOW_STATE',
}
export enum ScenesType {
  /**
   * 媒体中心
   */
  SCENES_MEDIA_CONTROL = 'MEDIA_CONTROL',

  /**
   * 控制中心
   */
  SCENES_CONTROL_CENTER = 'CONTROL_CENTER',

  /**
   * 通知中心
   */
  SCENES_NOTIFICATION = 'NOTIFICATION',

  /**
   * 锁屏列表态
   */
  SCENES_SCREEN_LOCK = 'SCREEN_LOCK',

  /**
   * 锁屏胶囊态
   */
  SCENES_SCREEN_LOCK_CAPSULE = 'SCREEN_LOCK_CAPSULE',

  /**
   * 锁屏沉浸态
   */
  SCENES_SCREEN_LOCK_IMMERSIVE = 'SCREEN_LOCK_IMMERSIVE',

  /**
   * 本端控制源
   */
  SCENES_MEDIA_CONTROL_SOURCE = 'MEDIA_CONTROL_SOURCE',

  /**
   * 远端端控制源
   */
  SCENES_MEDIA_CONTROL_SINK = 'MEDIA_CONTROL_SINK',

  /**
   * 本端应用控制源
   */
  SCENES_APP_DEVICE_LIST = 'APP_DEVICE_LIST',

  /**
   * 本端皮套
   */
  SCENES_COVER_LOCK = 'COVER_LOCK',

  /**
   * 大屏展开态媒体卡
   */
  SCENES_EXPAND_MEDIA_CARD = 'EXPAND_MEDIA_CARD'
}

// 触发方式
export enum TriggerMode {
  mediaDeviceListCast = 0, // 播控设备列表投播
  appComponentCast = 1, // 应用内组件投播
  sinkAVPlay = 2 // sink端播放器
}

// 功能场景
export enum BizScene {
  discoverDevice = 1, // 设备发现
  startCast = 2, //开始投播
  sourceController = 3, // source端投播控制
  castEnd = 4 // 投播结束
}

// 设备发现
export enum DiscoverDeviceList {
  startSearchDevice = 1, // 拉起设备列表开始搜索设备
  expendSearchDevice = 2 // 展开搜索的设备
}

// 启动投播
export enum StartCAST {
  selectCastDeviceStartCast = 1, // 用户选择设备发起投播
  deviceConnet = 2, // 设备链接
  sinkPlay = 3 // sink端资源播放
}

// source端投播控制
export enum SourceController {
  sendControlCommand = 1, // source端发送播控指令
  sendPrevNextCommand = 2, // 上下首播控指令
  sourceReceiveCallback = 3 // source端收到状态回调
}

// 投播结束
export enum CastEnd {
  sourceCastStart = 1, // source端开始断开投播
  sourceCastEnd = 2 // source端结束断开投播
}

export enum StageResult { // 阶段结果
  idle = 0,
  sussess = 1,
  fail = 2,
  cancel = 3,
  nuknow = 4
}

export enum BizState { // 业务模块的开始或结束
  middle = 0,
  start = 1,
  ending = 2
}

export enum IsTrust { // 是否可信
  unknown = 0,
  trust = 1,
  notTrust = 2
}

const FAULT_EVENT = new Set<EventType>([
  EventType.LOCAL_CONTROL_FAILED,
  EventType.MEDIA_ROUTER_UNEXPECTED_BEHAVIOR,
  EventType.JUMP_APP_FAIL
])

export class EventParam {
  private eventType: EventType;

  private type: hiSysEvent.EventType

  private extendParam: Map<string, Object> = new Map();

  private isUpload: boolean = false;

  constructor(eventType: EventType) {
    this.eventType = eventType;
    if (FAULT_EVENT.has(eventType)) {
      this.type = hiSysEvent.EventType.FAULT;
    } else {
      this.type = hiSysEvent.EventType.BEHAVIOR;
    }
  }

  public updateScenes(scenesType: ScenesType): EventParam {
    this.extendParam['SCENES'] = scenesType;
    return this;
  }

  public updateExtendParam(paramKey: string, paramValue: Object): EventParam {
    this.extendParam[paramKey] = paramValue;
    return this;
  }

  public updateAllExtendParam(params: Object): EventParam {
    if (params) {
      let keyValue : [string, Object][] = Object.entries(params);
      for (const keyValueArray of keyValue) {
        this.extendParam[keyValueArray[0]] = keyValueArray[1];
      }
    }
    return this;
  }

  public reset(): EventParam {
    this.isUpload = false;
    return this;
  }

  public reportEvent(isUE: boolean, reportFirst: boolean = false): void {
    if (this.isUpload && reportFirst) {
      log.warn(`dont reportEvent`);
      return;
    }
    if (isUE) {
      hiSysEvent.write({
        domain: MEDIACONTROL_UE,
        name: this.eventType,
        eventType: this.type,
        params: this.extendParam
      }).then(() => {
        log.showInfo(`${this.eventType} MEDIACONTROL_UE success.`);
      }).catch(() => {
        log.showInfo(`${this.eventType} MEDIACONTROL_UE error.`);
      })
    } else {
      hiSysEvent.write({
        domain: MEDIA_CONTROL_DOMAIN,
        name: this.eventType,
        eventType: this.type,
        params: this.extendParam
      }).then(() => {
        log.showInfo(`${this.eventType} MEDIA_CONTROL_DOMAIN success.`);
      }).catch(() => {
        log.showInfo(`${this.eventType} MEDIA_CONTROL_DOMAIN error.`);
      })
    }
    this.isUpload = true;
    this.extendParam = new Map();
  }
}