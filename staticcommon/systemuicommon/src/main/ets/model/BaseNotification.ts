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

import notificationManager from '@ohos.notificationManager';
import type image from '@ohos.multimedia.image';
import type { wantAgent, WantAgent } from '@kit.AbilityKit';
import bundleManager from '@ohos.bundle.bundleManager';
import { NotificationBaseContent, NotificationCreatorType, OverlayIconStyle } from './NotificationContent';
import systemSoundManager from '@ohos.multimedia.systemSoundManager';
import resourceManager from '@ohos.resourceManager';
import type { LiveViewData } from '../liveview/data/LiveViewData';
import type { IComponentData } from '../immersivekeyguardcommon/base/interface/IComponentData';
import type { IImmersiveData } from '../immersivekeyguardcommon/data/IImmersiveData';
import { NtfReminderConfig } from './NtfRemindFlags';
import type { ObservedItem } from './ObservedModel';
import { NotificationWantAgentInfo } from '../model/NotificationAppInfo';
import { HideBannerContentType } from '../constants/HideBannerContentType';
import { NtfControlConfig } from './NtfControlFlags';

/**
 * 默认分组组名
 */
const DEFAULT_GROUP_NAME = 'rank_group';

/**
 * 通知基类
 */
export class BaseNotification {
  /**
   * 通知id，是应用传过来的，同一应用的同一个ID表示更新通知
   */
  id: number;

  /**
   * 通知唯一标示
   */
  hashCode: string;

  /**
   * trace_id
   */
  traceId?: string;

  /**
   * 通知渠道类型
   */
  slotType: notificationManager.SlotType;

  /**
   * 是否在锁屏上隐藏实况通知
   */
  isHiddenInKg: boolean = false;

  /**
   * 是否进行时通知
   */
  isOngoing: boolean = false;

  /**
   * 是否在点击通知后删除通知
   */
  isAutoDelete: boolean = true;

  /**
   * 是否横幅样式显示
   */
  isShowHeadsUp: boolean = false;

  /**
   * 是否是常驻横幅
   */
  isHeadsUpStick: boolean = false;

  /**
   * 是否允许清除
   */
  isRemoveAllowed: boolean = true;

  /**
   * 应用请求不清除
   */
  isNoClear: boolean = false;

  /**
   * 是否只提醒一次
   */
  isAlertOnce: boolean = false;

  /**
   * 是否显示状态栏图标
   */
  isFloatingIcon: boolean = true;

  /**
   * 是否隐藏通知内容
   */
  isHideContent: boolean = false;

  /**
   * 应用是否处于加锁状态
   */
  isAppLocked: boolean = false;

  /**
   * 横幅通知是否隐藏内容
   */
  bannerHideContentMode: number = HideBannerContentType.FOLLOW_SYSTEM;

  /**
   * 是否置顶显示
   */
  isDisplayAtTop: boolean = false;

  /**
   * 通知展示所属应用包名
   */
  creatorBundleName: string;

  /**
   * 通知展示所属应用用户
   */
  creatorUserId?: number;

  /**
   * 通知创建者的UID。
   */
  creatorUid: number;

  /**
   * 代理创建通知的包信息
   */
  agentBundle?: notificationManager.BundleOption;

  /**
   * 应用名称
   */
  appLabel: string = '';

  /**
   * 应用名称，该字段会根据语言响应式变化
   */
  appName: ObservedItem<string>;

  /**
   * 应用图标
   */
  appIcon?: image.PixelMap | string;

  /**
   * 通知右侧大图标
   */
  largeIcon?: image.PixelMap;

  /**
   * 通知小图标
   */
  smallIcon?: image.PixelMap;

  /**
   * 堆叠图标
   */
  overlayIcon?: image.PixelMap;

  /**
   * 堆叠图标样式
   * 0: 圆形; 1: 方形; 2: 样式反转
   */
  overlayIconStyle?: OverlayIconStyle;

  /**
   * 原通知小图标,备份smallIcon
   */
  smallIconOrigin?: image.PixelMap;

  /**
   * 通知点击事件动作
   */
  wantAgent: WantAgent;

  /**
   * 通知不使用该wantAgent,仅用于push更新通知场景删除wantAgent,避免内存泄漏
   */
  removalWantAgent?: WantAgent;

  /**
   * 通知点击事件动作的详细信息
   */
  wantAgentInfo: NotificationWantAgentInfo;

  /**
   * 内容类型
   */
  contentType?: notificationManager.ContentType;

  /**
   * 通知发送时间
   */
  deliveryTime: number;

  /**
   *  自动清除的时间
   */
  autoDeletedTime?: number;

  /**
   * 通知分组组名
   */
  groupName: string = '';

  /**
   * 是否不校验免打扰，默认校验
   */
  isBypassDnd: boolean = false;

  /**
   * 响铃声音信息
   */
  sound?: string;

  /**
   * 自定义铃声文件
   */
  soundDescriptor?: resourceManager.RawFileDescriptor;

  /**
   * 自定义铃声响铃时长
   */
  soundDuration?: number;

  /**
   * 震动幅度
   */
  vibration?: number[];

  /**
   * 提醒方式
   */
  remindConfig: NtfReminderConfig;

  /**
   * 是否允许锁屏显示，默认允许
   */
  isLockScreenEnable: boolean = true;

  /**
   * 是否开启通知响铃
   */
  isSoundEnable: boolean = false;

  /**
   * 是否开启通知振动
   */
  isVibrationEnable: boolean = false;

  /**
   * 通知通道等级
   * 0 关闭通知
   * 1/2 静默通知
   * 3 锁屏、响铃通知
   * 4 横幅通知
   */
  slotLevel: notificationManager.SlotLevel = notificationManager.SlotLevel.LEVEL_NONE;

  /**
   * 播放铃声的类型
   */
  systemToneType: number = systemSoundManager.SystemToneType.SYSTEM_TONE_TYPE_NOTIFICATION;

  /**
   * 是否来自系统应用
   */
  isFromSystemApp?: boolean;

  /**
   * 是否可展开
   */
  isExpandable: boolean = false;

  /**
   * 是否不显示通知设置
   */
  isSettingIgnore: boolean = false;

  /**
   * 通知创建者类型
   */
  creatorType: NotificationCreatorType = NotificationCreatorType.APP;

  /**
   * 标识通知发送方的应用类型
   */
  bundleType: bundleManager.BundleType = bundleManager.BundleType.APP;

  /**
   * 是否为Push推送的通知
   */
  isFromPush: boolean = false;

  /**
   * 通知请求体
   */
  request?: notificationManager.NotificationRequest;

  /**
   * 通知渠道信息
   */
  slot?: notificationManager.NotificationSlot;

  /**
   * 通知内容
   */
  notificationContent: NotificationBaseContent;

  /**
   * 实况卡片、胶囊数据
   *
   */
  liveViewData?: LiveViewData;

  /**
   * 沉浸锁屏数据
   */
  immersiveKgData?: IComponentData;

  /**
   * 沉浸锁屏数据
   */
  immersiveNtfData: IImmersiveData;

  /**
   * 是否是普通通知转的实况，是该类型的时候，该通知的管理（开关设置等）应该当成普通通知而非实况
   */
  isConvertFromNormal: boolean = false;

  /**
   * 分身id，主应用是0，分身是1——5
   */
  appIndex: number = 0;

  /**
   * 分身标签图标资源
   */
  cloneLabelRes?: resourceManager.Resource;

  /**
   * 通知高级配置
   */
  controlConfig: NtfControlConfig;

  /**
   * Push携带的数据，打点需要用到
   */
  pushData?: Record<string, Object>;

  /**
   * 通知分类，用于感知VOIP/MISS_CALL
   */
  classification?: string;

  /**
   * 使用自定义应用名
   */
  useCustomAppname: boolean = false;

  /**
   * 排序权重值
   */
  sortWeight?: number;

  /**
   * 通知channelId
   */
  channelId?: string;

  /**
   * 是否为协同通知
   */
  isCollaNotification: boolean = false;

  /**
   * 全场景通知应用图标
   */
  collaAppIconOrigin?: image.PixelMap;

  constructor(data?: BaseNotification) {
    if (data) {
      Object.assign(this, data);
    }
  }

  /**
   * 是否为实况通知
   */
  isLiveType(): boolean {
    return this.slotType === notificationManager.SlotType.LIVE_VIEW;
  }

  /**
   * 是否为紧急通知
   */
  isEmergencyNtf(): boolean {
    return this.slotType === notificationManager.SlotType.EMERGENCY_INFORMATION;
  }

  /**
   * 获取通知分组标识
   *
   * @return 分组标识
   */
  getGroupKey(): string {
    return '';
  }

  /**
   * 是否为默认分组名
   *
   * @returns true:是; false:否
   */
  isDefaultGroupName(): boolean {
    return (this.groupName === DEFAULT_GROUP_NAME);
  }
}