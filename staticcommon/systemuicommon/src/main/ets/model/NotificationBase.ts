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

import notificationManager from '@ohos.notificationManager';
import type image from '@ohos.multimedia.image';
import type { wantAgent, WantAgent } from '@kit.AbilityKit';
import bundleManager from '@ohos.bundle.bundleManager';
import {
  NotificationAction,
  NotificationCategory,
  NotificationCreatorType,
  NotificationRole,
  OverlayIconStyle
} from './NotificationContent';
import type systemSoundManager from '@ohos.multimedia.systemSoundManager';
import type resourceManager from '@ohos.resourceManager';
import type { NotificationWantAgentInfo } from './NotificationAppInfo';
import type { NormalNotification } from './NormalNotification';
import type { NormalNotificationGroup } from './NormalNotificationGroup';
import type { LiveNotification } from '../live/model/LiveNotification';
import type { NtfControlConfig } from './NtfControlFlags';
import type { NtfReminderConfig } from './NtfRemindFlags';
import lazy { NotificationUtil } from '../utils/NotificationUtil';
import { notificationCcmConfig } from '../utils/NotificationCcmConfig';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SystemUICommonUtil } from '../utils/SystemUICommonUtil';

const log = LogHelper.getLogHelper(LogDomain.NC, 'NotificationBase');
let id = 0;
function getNextId(): number {
  if (id >= Number.MAX_SAFE_INTEGER) {
    id = 0;
  }
  return id++;
}

/**
 * 下半区通知分类列表
 */
const MORE_NTF_CATEGORY_LIST: NotificationCategory[] = [
  NotificationCategory.CAMPAIGN_MORE_TOP,
  NotificationCategory.OTHER,
];

/**
 * 通知基类
 */
export class NotificationBase {
  /**
   * 通知角色
   */
  readonly role: NotificationRole;

  /**
   * 通知对象唯一标识
   */
  readonly uid: string;

  /**
   * 通知对象生命周期内的唯一标识，同一个HashCode通知在创建、更新时一致，删除后会重新生成，用来标识VM
   */
  key: string;

  /**
   * 通知分类
   */
  category: NotificationCategory;

  /**
   * 内容类型
   */
  contentType?: notificationManager.ContentType;

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
   * 通知渠道级别
   */
  slotLevel: notificationManager.SlotLevel = notificationManager.SlotLevel.LEVEL_NONE;

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
   * 是否是常驻横幅
   */
  isHeadsUpStick: boolean = false;

  /**
   * 是否可被左滑删除
   */
  isRemoveAllowed: boolean = true;

  /**
   * 是否可被一键清除
   */
  isClearAllowed: boolean = true;

  /**
   * 相同通知是否只在创建时提醒一次
   */
  isAlertOnce: boolean = false;

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
  creatorUserId: number;

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
   * 应用版本
   */
  appVersionName: string = '';

  /**
   * 应用图标
   */
  appIcon?: string | image.PixelMap;

  /**
   * 通知右侧大图标
   */
  largeIcon?: image.PixelMap;

  /**
   * 通知小图标
   */
  smallIcon?: image.PixelMap;

  /**
   * 堆叠图标样式
   * 0: 圆形; 1: 方形; 2: 样式反转
   */
  overlayIconStyle?: OverlayIconStyle;

  /**
   * 原始通知小图标
   */
  smallIconOrigin?: image.PixelMap;

  /**
   * 堆叠图标
   */
  overlayIcon?: image.PixelMap;

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
   * 通知发送时间，排序和显示使用
   */
  deliveryTime: number;

  /**
   * 是否为协同通知
   */
  isCollaNotification: boolean = false;

  /**
   * 全场景通知应用图标
   */
  collaAppIconOrigin?: image.PixelMap;

  /**
   * 是否不显示通知设置
   */
  isSettingIgnore: boolean = false;

  /**
   * 通知分组key
   */
  groupKey: string = '';

  /**
   * 响铃文件路径
   */
  sound?: string;

  /**
   * 自定义铃声文件描述符
   */
  customSound?: resourceManager.RawFileDescriptor;

  /**
   * 自定义铃声响铃时长
   */
  soundDuration?: number;

  /**
   * 震动幅度
   */
  vibration?: number[];

  /**
   * 是否开启通知响铃
   */
  isSoundEnable: boolean = false;

  /**
   * 是否开启通知振动
   */
  isVibrationEnable: boolean = false;

  /**
   * 是否显示锁屏通知
   */
  isLockScreenEnable: boolean = false;

  /**
   * 播放铃声的类型
   */
  systemToneType?: systemSoundManager.SystemToneType;

  /**
   * 是否来自系统应用
   */
  isFromSystemApp?: boolean;

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
   * 分身id，主应用是0，分身是1——5
   */
  appIndex: number = 0;

  /**
   * 是否横幅通知
   */
  isHeadsUp: boolean = false;

  /**
   * 是否状态栏显示图标
   */
  isShowStatusBarIcon: boolean = false;

  /**
   * 分组名称
   */
  groupName?: string;

  /**
   * 通知提醒配置
   */
  remindConfig: NtfReminderConfig;

  /**
   * 通知高级配置
   */
  controlConfig: NtfControlConfig;

  /**
   * Push携带的数据，打点需要用到
   */
  pushData?: Record<string, Object>;

  /**
   * 通知按钮集
   */
  actionButtons?: NotificationAction[];

  /**
   * channelId
   */
  channelId?: string;

  /**
   * 通知分类，用于感知VOIP/MISS_CALL
   */
  classification?: string;

  /**
   * 使用自定义应用图标
   */
  useCustomAppIcon: boolean = false;

  /**
  * 使用自定义应用名
  */
  useCustomAppname: boolean = false;

  /**
   * 构造通知对象
   */
  constructor() {
    // 时间戳+随机数生成唯一标识uid
    this.uid = Date.now() + '_' + Math.random().toString(16).substring(2);
  }
  /**
   * 是否为紧急通知
   */
  isEmergencyNtf(): boolean {
    return this.slotType === notificationManager.SlotType.EMERGENCY_INFORMATION;
  }

  /**
   * 是否为下半区通知
   */
  isMoreNtf(): boolean {
    return MORE_NTF_CATEGORY_LIST.includes(this.category);
  }

  /*
   * 是否为普通通知
   */
  isNormal(): this is NormalNotification {
    return this.role === NotificationRole.NORMAL;
  }

  /**
   * 是否为组通知
   */
  isNormalGroup(): this is NormalNotificationGroup {
    return this.role === NotificationRole.NORMAL_GROUP;
  }

  /**
   * 是否为实况通知
   */
  isLiveView(): this is LiveNotification {
    return this.role === NotificationRole.LIVE_VIEW;
  }

  /**
   * 是否为安装元服务
   */
  isInstallMetaSer: boolean = true;

  /**
   * 未安装元服务应用名
   */
  unstallMetaSerBoundName: string = '';

  /**
   * 更新通知标识信息
   */
  updateKey(key?: string, onlyUpdateKey: boolean = false): void {
    if (!onlyUpdateKey) {
      this.category = this.getCategory();
      this.groupKey = this.getGroupKey();
    }
    const oldKey = this.key;
    this.key = key ?? `${this.hashCode}-${getNextId()}`;
    if (this.key !== oldKey) {
      log.showInfo(`updateKey, oldKey: ${oldKey}, newKey: ${this.key}, stack: ${new Error().stack}`);
    }
  }

  /**
   * 获取显示的应用图标
   * @param isOnlyUseAppIcon 是否仅使用应用图标而不判断smallIcon，默认false
   * @returns 返回显示的应用图标
   */
  getAppIcon(isOnlyUseAppIcon: boolean = false): image.PixelMap | string | undefined {
    // 部分系统应用没有应用图标
    if (isOnlyUseAppIcon && this.appIcon) {
      return this.appIcon;
    }
    // 系统应用支持自定义图标，使用小图标代替应用图标
    if (this.isFromSystemApp && this.smallIcon) {
      return this.smallIcon;
    }
    return this.appIcon;
  }

  /**
   * 获取显示的大图标
   * @returns返回显示的大图标
   */
  getBigIcon(): image.PixelMap | string | undefined {
    if (this.overlayIconStyle === OverlayIconStyle.REVERSE) {
      return this.getAppIcon();
    }
    return this.overlayIcon;
  }

  toSimpleString(): string {
    return this.key;
  }

  /**
   * 克隆一个新的通知对象，用于数据更新
   * @returns
   */
  clone(): NotificationBase {
    const newNtf = new (this.constructor as typeof Object)() as NotificationBase;
    // 使用老的通知值更新通知，这里只需要更新最外层对象引用，使用浅拷贝。uid使用新生成的，避免被传入的对象覆盖
    Object.assign(newNtf, this, { uid: newNtf.uid });
    newNtf.updateKey(this.key);
    return newNtf;
  }

  protected getCategory(): NotificationCategory {
    if (this.slotType === notificationManager.SlotType.EMERGENCY_INFORMATION) {
      return NotificationCategory.EMERGENCY;
    } else if (this.slotType === notificationManager.SlotType.LIVE_VIEW) {
      return NotificationCategory.LIVE_VIEW;
    } else if (this.isDisplayAtTop) {
      return NotificationCategory.PIN_TOP;
    } else if (this.slotType === notificationManager.SlotType.SERVICE_INFORMATION ||
      this.slotType === notificationManager.SlotType.SOCIAL_COMMUNICATION ||
      this.slotType === notificationManager.SlotType.CUSTOMER_SERVICE) {
      return NotificationCategory.NORMAL;
    } else if (this.slotType === notificationManager.SlotType.CONTENT_INFORMATION) {
      if (this.controlConfig.isMainTopCampaignNtf()) {
        return NotificationCategory.CAMPAIGN_MAIN_TOP;
      }
      if (this.controlConfig.isMoreTopCampaignNtf()) {
        return NotificationCategory.CAMPAIGN_MORE_TOP;
      }
    }
    return NotificationCategory.OTHER;
  }

  protected getGroupKey(): string {
    if (this.isLiveView() || this.isEmergencyNtf()) { // 实况和紧急通知独立分组
      return `${this.hashCode}_${this.category}`;
    } else if (this.groupName) { // 有设置分组名称直接使用
      return `${this.creatorBundleName}_${this.creatorUid}_${this.category}_${this.groupName}`;
    } else {
      return `${this.creatorBundleName}_${this.creatorUid}_${this.category}`;
    }
  }

  public enableHeadsUp(isEnable: boolean): void {
      this.isHeadsUp = isEnable;
  }

  /**
   * 统一释放图片资源
   *
   * @param newNtf 新通知数据，用于与旧通知图片资源做对比，如果新旧图片资源相同则无需释放
   */
  public releaseImages(newNtf?: NotificationBase): void {
    SystemUICommonUtil.releaseImage(this.largeIcon);
    SystemUICommonUtil.releaseImage(this.smallIcon);
    SystemUICommonUtil.releaseImage(this.smallIconOrigin);
    SystemUICommonUtil.releaseImage(this.overlayIcon);
    SystemUICommonUtil.releaseImage(this.collaAppIconOrigin);
  }

  /**
   * 是否为默认分组名
   *
   * @returns true:是; false:否
   */
  isDefaultGroupName(): boolean {
    return !this.groupName;
  }
}

/**
 * 通知数组
 */
export class NotificationArray<T extends NotificationBase = NotificationBase> extends Array<T> {

  /**
   * 删除指定HashCode的通知
   * @param hashCode
   */
  public remove(hashCode: string): void {
    const index = this.findIndex((live) => live.hashCode === hashCode);
    if (index > -1) {
      this.splice(index, 1);
    }
  }

  /**
   * 清除所有数据
   */
  public clear(): void {
    if (!this.length) {
      return;
    }
    this.splice(0, this.length);
  }

  /**
   * 通知排序
   * @returns
   */
  public sort(): this {
    return super.sort((a, b) => NotificationUtil.sortComparer(a, b, NotificationUtil.getLivePriority));
  }

  /**
   * 实况胶囊通知排序
   * @returns
   */
  public sortCapsuleList(): this {
    return super.sort((a, b) => NotificationUtil.sortComparer(a, b, NotificationUtil.getCapsuleListPriority));
  }
}

/**
 * 主线程非锁屏模块需要使用的通知数据，每次发通知都需要跨线程传递，只提供必要字段
 */
export interface NotificationBaseForBridge {
  /**
   * 通知唯一标示
   */
  hashCode: string;
  /**
   * 通知id，是应用传过来的，同一应用的同一个ID表示更新通知
   */
  id: number;
  /**
   * 通知创建者的UID。
   */
  creatorUid: number;
  /**
   * 是否为实况通知
   */
  isLiveView: boolean;

  /**
   * 通知通道类型
   */
  slotType: notificationManager.SlotType;
  /**
   * 实况卡片组件绑定数据信息
   */
  liveViewData?: {
    /**
     * 实况场景
     */
    event?: string;
    /**
     * 操作类型：0--创建，1--局部更新，2--结束，3--全量刷新
     */
    status?: number;

    /**
     * 是否支持锁屏沉浸态
     */
    isSupportImm?: boolean;
  }
}