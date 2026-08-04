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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import type { Equality } from '@ohos/basicutils';
import {
  CapsuleStatus,
  CapsuleType,
  LiveExtendType,
  LiveType,
  LiveUseScene,
  LiveViewCommonConstants,
  LiveViewShowType,
  SysTypeCode
} from '../common/LiveConstants';
import { LiveViewDataStatus } from '../common/LiveConstants';
import type { LiveCapsuleData } from './capsule/LiveCapsuleData';
import type { ILiveTemplateData } from '../common/ILiveTemplateData';
import { BaseExtendProperty } from '../../base/common/info/BaseExtendProperty';
import type { IUpdatable } from '../../base/common/interface/IUpdatable';
import type { LiveTimerData } from './extend/LiveTimerData';
import type { LiveSystemTemplate } from './template/LiveSystemTemplate';
import type { LiveButtonArray } from './extend/LiveButtonData';
import type { LiveProgressData } from './extend/LiveProgressData';
import type { ILiveExtendData } from '../common/ILiveExtendData';
import transResToPicHelper from '../parse/utils/TransResToPicHelper';
import notificationManager from '@ohos.notificationManager';
import { OtherBaseTemplate } from './template/OtherBaseTemplate';
import resourceManager from '@ohos.resourceManager';
import { ObservedItem } from '../../model/ObservedModel';
import { bannerMgr } from '../../banner/phone/BannerManager';

const TAG = 'LiveViewData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 实况卡片组件绑定数据信息
 */
@Observed
export class LiveViewData extends BaseExtendProperty implements Equality, IUpdatable {
  /**
   * 实况数据是否超时，无需触发observe刷新
   * 数据超过2小时未更新，则认为数据超时失效
   */
  private isTimeout: boolean = false;

  /**
   * 实况类型(0-进度类，1-即时，2-长时)
   */
  type?: number;

  /**
   * 通知唯一标示
   */
  hashCode: string;

  /**
   * 通知所属应用包名
   */
  creatorBundleName: string;

  /**
   * 通知所属应用唯一标示
   */
  creatorUid: number;

  /**
   *通知展示所属应用用户
   */
  creatorUserId?: number | undefined;

  /**
   * 代理创建通知的包信息
   */
  agentBundle?: notificationManager.BundleOption;

  /**
   * 实况场景，用于元服务实况窗场景
   */
  event?: string;

  /**
   * 通知发送时间
   */
  deliveryTime: number;

  /**
   * 通知创建时间
   * 新增通知赋值后，后续更新不修改
   */
  createTime: number;

  /**
   * 通知id
   */
  id: number;

  /**
   *  自动清除的时间，实况窗结束时需要传删除时间
   */
  keepTime?: number = 0;

  /**
   * 是否允许清除
   * 系统APP使用，不显示侧滑删除按钮，不允许清除
   */
  isRemoveAllowed: boolean = true;

  /**
   * 是否允许设置实况窗开关
   */
  isEditSwitchAllowed: boolean = true;

  /**
   * 操作类型：0--创建，1--局部更新，2--结束，3--全量刷新
   */
  status?: LiveViewDataStatus;

  /**
   * 数据显示类型
   */
  liveViewShowType: LiveViewShowType = LiveViewShowType.NONE;

  /**
   * 卡片类型
   */
  liveType: LiveType = LiveType.TYPE_SYSTEM;

  /**
   * 系统实况类型码，标示系统对应应用
   */
  sysTypeCode: SysTypeCode = SysTypeCode.OTHER;

  /**
   * 卡片模板数据
   */
  template: ILiveTemplateData;

  /**
   * 胶囊数据
   */
  capsule?: LiveCapsuleData;

  /**
   * 应用名称，该字段会根据语言响应式变化
   */
  appName?: ObservedItem<string>;

  /**
   * 应用名称，应用自定义无障碍朗读文本
   */
  customerAccessibilityText?: string;

  /**
   * 标识消息更新是否需要提醒
   */
  isMute?: boolean = true;

  /**
   * 图标点击监听器
   */
  iconClickListener?: ILiveIconClickListener;

  /**
   * 分组标识
   */
  groupKey: string;

  /**
   * 是否显示授权提示框
   */
  showAuthorization: boolean = false;

  /**
   * 是否分身应用
   */
  appIndex: number = 0;

  /**
   * 分表图标资源
   */
  cloneLabelRes?: resourceManager.Resource;

  /**
   * 是否来自Push推送的元服务实况，服务动态实况
   */
  isAtomicServiceFromPush: boolean = false;

  /**
   * 是否是通知
   */
  isDeliverNotification: boolean = false;

  /**
   * 是否隐藏实况通知内容
   */
  isHideContent: boolean = false;

  /**
   * 隐藏实况通知内容显示文本
   */
  contentHideText: string = '';

  /**
   * 是否显示在卡片
   */
  isShowingInCard: boolean = false;

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    if (!(other instanceof LiveViewData)) {
      return;
    }

    let otherData = other as LiveViewData;
    transResToPicHelper.start(otherData.creatorBundleName);
    // 强制刷新场景或模板类型改变场景，强制更新卡片模板
    if (forceRefresh || CommonUtils.isInvalid(this.template) ||
      this.isTemplateTypeChanged(this.liveType, otherData.liveType)) {
      const oldTimer: LiveTimerData = (this.template as OtherBaseTemplate).timer;
      const otherTimer: LiveTimerData = (otherData.template as OtherBaseTemplate).timer;
      oldTimer?.update(otherTimer);
      // 将老对象上的计时器替换到新的模板对象上，因为计时器在老的上面更新
      (otherData.template as OtherBaseTemplate).timer = oldTimer;
      this.setTemplate(otherData.template, forceRefresh);
    } else {
      this.template?.update(otherData.template, forceRefresh, otherData.creatorBundleName);
    }

    this.setDataTimeout(otherData.isTimeout);
    this.setCreatorBundleName(otherData.creatorBundleName, forceRefresh);
    this.setCreatorUid(otherData.creatorUid, forceRefresh);
    this.setDeliveryTime(otherData.deliveryTime, forceRefresh);
    this.setId(otherData.id, forceRefresh);
    this.setKeepTime(otherData.keepTime, forceRefresh);
    this.setStatus(otherData.status, forceRefresh);
    this.setLiveType(otherData.liveType, forceRefresh);
    this.setSysTypeCode(otherData.sysTypeCode, forceRefresh);
    this.setIconClickListener(otherData.iconClickListener, forceRefresh);

    // 更新胶囊
    const isBroadCastingUpdate = this.sysTypeCode === SysTypeCode.BROADCASTING_CENTER &&
      CommonUtils.isInvalid(otherData.capsule);
    if (forceRefresh || CommonUtils.isInvalid(this.capsule) || isBroadCastingUpdate) {
      // 强制刷新场景或新数据不带胶囊数据时，强制刷新胶囊字段
      if (isBroadCastingUpdate) {
        // 新的播控数据未携带胶囊数据，不覆盖原胶囊数据，只更新原胶囊状态
        this.capsule?.setCapsuleStatus(CapsuleStatus.STATUS_FINISH);
      } else {
        this.setCapsule(otherData.capsule, true);
      }
    } else {
      this.capsule?.update(otherData.capsule, forceRefresh);
    }
    transResToPicHelper.end();
  }

  /**
   * 设置数据是否已超时
   *
   * @param isTimeout true超时
   */
  setDataTimeout(isTimeout: boolean): void {
    this.isTimeout = isTimeout;
  }

  /**
   * 当前数据是否已超时
   *
   * @returns true已超时
   */
  isDataTimeout(): boolean {
    // 系统实况，不存在超时限制
    if (this.isLiveSystem()) {
      return false;
    }
    return this.isTimeout;
  }

  /**
   * 该条数据是否异常
   *
   * @returns true异常
   */
  isDataInvalid(): boolean {
    // 超时未更新
    return this.isDataTimeout() ||
      // 实况周期已结束
      this.status === LiveViewDataStatus.END ||
      // 胶囊周期已结束
      this.capsule?.status === CapsuleStatus.STATUS_FINISH;
  }

  /**
   * 创建通知的应用包名
   *
   * @param creatorBundleName 创建通知的应用包名
   * @param forceRefresh 是否强制刷新
   */
  setCreatorBundleName(creatorBundleName?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(creatorBundleName)) {
      this.creatorBundleName = creatorBundleName;
    }
  }

  /**
   * 设置创建通知的uid
   *
   * @param creatorUid 创建通知的uid
   * @param forceRefresh 是否强制刷新
   */
  setCreatorUid(creatorUid?: number, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(creatorUid)) {
      this.creatorUid = creatorUid;
    }
  }

  /**
   * 设置通知发送事件
   *
   * @param deliveryTime 通知发送事件
   * @param forceRefresh 是否强制刷新
   */
  setDeliveryTime(deliveryTime?: number, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(deliveryTime)) {
      this.deliveryTime = deliveryTime;
    }
  }

  /**
   * 设置创建通知的id
   *
   * @param id 通知的id
   * @param forceRefresh 是否强制刷新
   */
  setId(id?: number, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(id)) {
      this.id = id;
    }
  }

  /**
   * 设置keepTime
   *
   * @param keepTime number
   * @param forceRefresh 是否强制刷新
   */
  setKeepTime(keepTime?: number, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(keepTime)) {
      this.keepTime = keepTime;
    }
  }

  /**
   * 设置status
   *
   * @param status LiveViewDataStatus
   * @param forceRefresh 是否强制刷新
   */
  setStatus(status?: LiveViewDataStatus, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(status)) {
      this.status = status;
    }
  }

  /**
   * 设置实况类型
   *
   * @param liveType 实况类型
   * @param forceRefresh 是否强制刷新
   */
  setLiveType(liveType?: LiveType, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(liveType)) {
      this.liveType = liveType;
    }
  }

  /**
   * 是否为系统实况通知
   *
   * @returns true系统实况
   */
  isLiveSystem(): boolean {
    return this.liveType === LiveType.TYPE_SYSTEM;
  }

  /**
   * 设置isMute
   *
   * @param isMute 标识消息更新是否需要提醒
   * @param forceRefresh 是否强制刷新
   */
  setIsMute(isMute?: boolean, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(isMute)) {
      this.isMute = isMute;
    }
  }

  /**
   * 设置系统类型码，标示系统对应应用
   *
   * @param typeCode 类型码
   * @param forceRefresh 是否强制刷新
   */
  setSysTypeCode(typeCode?: SysTypeCode, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(typeCode)) {
      this.sysTypeCode = typeCode;
    }
  }

  /**
   * 是否为对应系统类型
   *
   * @param typeCode 目标类型码
   * @returns true当前为目标系统类型
   */
  isSysTypeCode(typeCode: SysTypeCode): boolean {
    return this.sysTypeCode === typeCode;
  }

  /**
   * 设置实况卡片模板
   *
   * @param template 模板数据
   * @param forceRefresh 是否强制刷新
   */
  setTemplate(template?: ILiveTemplateData, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(template)) {
      this.template = template;
    }
  }

  /**
   * 设置实况计时
   *
   * @param timer 计时数据
   * @param forceRefresh 是否强制刷新
   */
  setTemplateTimer(timer?: LiveTimerData, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(timer)) {
      const template = this.template as OtherBaseTemplate;
      template.updateLiveTimer(timer);
    }
  }

  /**
   * 设置是否为实况计时标识符
   *
   * @param timer 计时数据
   * @param forceRefresh 是否强制刷新
   */
  setIsTemplateTimer(template?: ILiveTemplateData, forceRefresh?: boolean): void {
    const isTimer = (template as OtherBaseTemplate).isTimeTemplate;
    if (forceRefresh || !CommonUtils.isInvalid(isTimer)) {
      const templateTimer = this.template as OtherBaseTemplate;
      templateTimer.setIsTimeTemplate(isTimer);
    }
  }

  /**
   * 设置实况胶囊数据
   *
   * @param capsule 胶囊数据
   * @param forceRefresh 是否强制刷新
   */
  setCapsule(capsule?: LiveCapsuleData, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(capsule)) {
      this.capsule = capsule;
    }
  }

  /**
   * 更新授权显示
   */
  updateShowAuth(): void {
    this.showAuthorization = false;
  }

  /**
   * 设置卡片图标点击监听
   *
   * @param listener 监听器
   * @param forceRefresh 是否强制刷新
   */
  setIconClickListener(listener?: ILiveIconClickListener, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(listener)) {
      this.iconClickListener = listener;
    }
  }

  /**
   * 是否带有胶囊
   *
   * @returns true带有胶囊
   */
  hasCapsuleData(): boolean {
    return !CommonUtils.isInvalid(this.capsule);
  }

  /**
   * 复写，相等比较
   *
   * @param other 待比较对象
   * @returns true相等
   */
  equals(other: object): boolean {
    if (!(other instanceof LiveViewData)) {
      return false;
    }
    let otherData = other as LiveViewData;
    return this.hashCode === otherData.hashCode;
  }

  /**
   * 获取计时器类型数据
   *
   * @returns 计时器
   */
  getTimerData(): LiveTimerData | undefined {
    if (this.capsule?.type !== CapsuleType.TYPE_TIMER) {
      return undefined;
    }
    return this.capsule?.getCapsuleTypeData() as LiveTimerData;
  }

  /**
   * 获取计时器
   *
   * @returns 计时器
   */
  getTemplateTimer(): LiveTimerData | undefined {
    if (!(this.template as OtherBaseTemplate)?.isTimeTemplate) {
      return undefined;
    }
    return (this.template as OtherBaseTemplate).timer;
  }

  getTemplateTitle(): string | undefined {
    if (!(this.template as OtherBaseTemplate)?.isTimeTemplate) {
      return undefined;
    }
    return (this.template as OtherBaseTemplate).title;
  }

  /**
   * 获取多按钮类型数据
   *
   * @returns 多按钮
   */
  getButtonData(): LiveButtonArray | undefined {
    let buttons = this.getSystemExtendData(LiveExtendType.TYPE_COMMON_BUTTON);
    if (buttons) {
      return buttons as LiveButtonArray;
    }
    return undefined;
  }

  /**
   * 获取进度类型数据
   *
   * @returns 进度条
   */
  getProgressData(): LiveProgressData {
    return this.getSystemExtendData(LiveExtendType.TYPE_COMMON_PROGRESS) as LiveProgressData;
  }

  /**
   * 初始化应用自定义无障碍朗读文本
   */
  setCustomerAccessibilityText(customerAccessibilityText: string): void {
    if (!CommonUtils.isInvalid(customerAccessibilityText)) {
      this.customerAccessibilityText = customerAccessibilityText;
    }
  }

  /**
   * 初始化appIndex
   * @param appIndex
   */
  setAppIndex(appIndex: number): void {
    this.appIndex = appIndex;
  }

  /**
   * 初始化分身标签图标
   */
  setCloneLabel(cloneLabelRes: resourceManager.Resource): void {
    this.cloneLabelRes = cloneLabelRes;
  }

  shouldHideContent(useScene: LiveUseScene, isNeedBannerInScreenLock: boolean, isShowBannerFromScreenLock: boolean):
    boolean {
    if (useScene === LiveUseScene.SCENE_SCREEN_LOCK) {
      return this.isHideContent;
    }
    if (bannerMgr.isLiveListInScreenLock(useScene, isNeedBannerInScreenLock, isShowBannerFromScreenLock)) {
      return this.isHideContent;
    }
    if (bannerMgr.isHeadsUpInScreenLock(useScene, isNeedBannerInScreenLock, isShowBannerFromScreenLock)) {
      return this.isHideContent;
    }
    return false;
  }

  getIconClickListener(useScene: LiveUseScene, isNeedBannerInScreenLock: boolean, isShowBannerFromScreenLock: boolean):
  (() => void) | undefined {
    log.showInfo('useScene:' + useScene + ', isHideContent:' + this.isHideContent +
      ', screenLockStateInfo' + isNeedBannerInScreenLock +
    ', isShowBannerFromScreenLock' + isShowBannerFromScreenLock);
    if (useScene === LiveUseScene.SCENE_SCREEN_LOCK) {
      return this.isHideContent || !this.iconClickListener ? undefined : (): void => {
        this.iconClickListener?.onIconClick(useScene, this.groupKey);
      };
    }
    if (bannerMgr.isLiveListInScreenLock(useScene, isNeedBannerInScreenLock, isShowBannerFromScreenLock)) {
      return this.isHideContent || !this.iconClickListener ? undefined : (): void => {
        this.iconClickListener?.onIconClick(useScene, this.groupKey);
      };
    }
    return undefined;
  }

  /**
   * 获取系统模板扩展数据
   *
   * @param extendType 扩展类型
   * @returns 扩展数据
   */
  private getSystemExtendData(extendType: LiveExtendType): ILiveExtendData | undefined {
    if (this.liveType !== LiveType.TYPE_SYSTEM) {
      return undefined;
    }
    let template: LiveSystemTemplate = this.template as LiveSystemTemplate;
    if (!template?.hasExtendData(extendType)) {
      return undefined;
    }
    return template?.getExtendData(extendType);
  }

  /**
   * 实况模板数据类型是否变更
   *
   * @param oldType old类型
   * @param newType new类型
   * @returns true已变更
   */
  private isTemplateTypeChanged(oldType: LiveType, newType: LiveType): boolean {
    return oldType !== newType;
  }

  /**
   * 释放PixelMap对象
   */
  releaseImages(): void {
    // 只能释放通过资源路径解析出来的实况图片
    this.capsule?.releaseImages();
    if (this.template instanceof OtherBaseTemplate) {
      this.template?.releaseImages();
    }
  }
}

/**
 * 实况数据列表
 * 用于state装饰器关联
 */
@Observed
export class LiveViewDataArray extends Array<LiveViewData> {
}

/**
 * 实况卡片图标点击事件
 */
export interface ILiveIconClickListener {
  /**
   * 处理头像点击事件
   *
   * @param groupKey
   */
  onIconClick(scene: LiveUseScene, groupKey: string): void;
}