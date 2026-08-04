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

import { image } from '@kit.ImageKit';
import { WantAgent } from '@kit.AbilityKit';
import { ArrayUtils } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { NotificationBase,
  SysTypeCode,
  LiveCardType,
  LiveExtensionType,
  LiveTimerModel,
  LiveProgressModel,
  LiveButtonModel} from '@ohos/systemuicommon/newTsIndex';
import { OverlayIconStyle } from '@ohos/systemuicommon';
import { ImmDataHelper } from '@ohos/screenlockcommon';
import { ImmDataType, ImmPrivacyType } from '../../../common/ImmersiveConstants';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';
import { slImmBindSt, SlImmBindStateV2 } from './SlImmBindStateV2';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';

// 组通知取Child索引
const MAIN_INDEX = 0;

// 最少隐藏个数
const MIN_HIDE_COUNT: number = 1;

// 拷贝实例后缀
const COPY_SUFFIX: string = 'copy';

/**
 * 沉浸模块数据基类
 */
@ObservedV2
export abstract class ImmBaseData<T extends ImmBaseData<T>> {
  // 实况业务注入器
  @Trace protected _liveVmInjector?: IImmersiveLiveVmInjector;

  // 通知解析原数据
  @Trace protected _oriData: NotificationBase = new NotificationBase();

  // 实例的唯一标识
  @Trace protected _uid: string = '';

  // 通知数据唯一标识
  @Trace protected _hashcode: string = '';

  // 分组标识
  @Trace protected _groupKey: string = '';

  // 数据列表中分组标识，用于区分copy数据
  @Trace protected _dataGroupKey: string = '';

  // 标识是否为copy数据
  @Trace protected _isCopyData: boolean = false;

  // 左上角应用名称
  @Trace protected _appName: string = '';

  // 原主标题，通用标题文本
  @Trace protected _oriTitle?: string;

  // 原主内容，通用内容文本
  @Trace protected _oriContent?: string;

  // 是否覆盖小图标为对称样式（克隆应用图标）
  @Trace protected _isOverlayReverse: boolean = false;

  // 左上角应用图标
  @Trace protected _appIcon?: string | image.PixelMap;

  // overlay大图标
  @Trace protected _overlayIcon?: image.PixelMap;

  // 小图标，替代应用图标
  @Trace protected _smallIcon?: image.PixelMap;

  // 通知点击agent动作
  @Trace protected _clickAgent?: WantAgent;

  // 分身应用index，主应用是0，分身是1——5
  @Trace protected _appIndex: number = 0;

  // 子通知个数，组通知场景记录个数
  @Trace protected _childrenCount: number = 0;

  // 沉浸态状态，主要隐私类型
  @Trace protected _immBindSt: SlImmBindStateV2 = slImmBindSt;

  // 实况大类型区分
  @Trace protected _liveTypeCode?: SysTypeCode;

  // 三方实况小类型区分
  @Trace protected _liveType?: LiveCardType;

  // 三方实况扩展区类型，默认不显示
  @Trace protected _otherExtensionType: LiveExtensionType = LiveExtensionType.DEFAULT;

  // 三方实况导航类型，转向图标
  @Trace protected _currNavDirectionIcon?: image.PixelMap;

  // 三方实况导航转向图标是否为svg或png
  @Trace protected _isNavIconSvgOrPng?: boolean;

  // 系统/三方实况计时器数据
  @Trace protected _liveTimer?: LiveTimerModel;

  // 计时器是否显示在title位置
  @Trace protected _isTimerInTitle: boolean = false;

  // 系统实况进度条
  @Trace protected _sysProgress?: LiveProgressModel;

  // 系统实况按钮列表
  @Trace protected _sysButtons?: LiveButtonModel[];

  // 三方实况辅助区点击动作
  @Trace protected _extWantAgent?: WantAgent;

  // 沉浸大卡权益管控值
  @Trace protected _immerCardAuthLevel?: number;

  /**
   * 通知数据是否含有沉浸大卡数据
   *
   * @param ntf 通知数据
   * @returns true含有沉浸大卡
   */
  public static hasImmCard(ntf: NotificationBase): boolean {
    return ntf?.isLiveView() && ntf?.card &&
      (Boolean(ntf.card.immersivePic) || Boolean(ntf.card.immersiveWant) || ntf.isMediaPlayer());
  }

  /**
   * 构造
   *
   * @param oriData 原通知数据
   */
  constructor(oriData: NotificationBase) {
    this.updateData(oriData);
  }

  /**
   * 标示数据类型
   *
   * @returns 数据类型
   */
  protected abstract getImmDataType(): ImmDataType;

  /**
   * 构建数据新实例
   *
   * @returns 新实例
   */
  protected abstract createNewData(): T;

  /**
   * 隐私场景主文本
   *
   * @returns 主文本
   */
  protected getPrivacyTitleText(): string | undefined {
    if (this.isDataPrivacy()) {
      return this._appName;
    }
    return undefined;
  }

  /**
   * 隐私场景副文本
   *
   * @param children 子通知个数
   * @returns 副文本
   */
  protected getPrivacyContentText(children: number): ResourceStr | undefined {
    // 应用锁/隐藏内容场景，保持一致
    if (this.isAppLock() || this.isHideContent()) {
      let count = Math.max(children, MIN_HIDE_COUNT);
      // 实况、普通区分文本内容
      let res = this.isLiveData() ? $r('app.plural.live_hide_content') : $r('app.plural.ntf_hide_content_tip');
      return ResUtils.getInnerPluralByResource(res, count);
    }
    return undefined;
  }

  /**
   * AOD场景判断
   *
   * @returns true AOD
   */
  protected isAod(): boolean {
    return this._immBindSt?.isAodMode() ?? false;
  }

  /**
   * 属性还原
   */
  protected resetProperty(): void {
    this._oriTitle = undefined;
    this._oriContent = undefined;
    this._liveTypeCode = undefined;
    this._liveType = undefined;
    this._currNavDirectionIcon = undefined;
    this._childrenCount = 0;
    this._otherExtensionType = LiveExtensionType.DEFAULT;
    this._liveTimer = undefined;
    this._isTimerInTitle = false;
    this._sysProgress = undefined;
    this._sysButtons = undefined;
    this._extWantAgent = undefined;
    this._immerCardAuthLevel = undefined;
  }

  /**
   * 更新数据
   *
   * @param update 新数据
   */
  public updateData(update: NotificationBase): void {
    if (!update) {
      return;
    }
    this._oriData = update;
    this._uid = update.uid;
    this._hashcode = update.hashCode;
    this._groupKey = update.groupKey;
    this._dataGroupKey = update.groupKey;
    this._isCopyData = false;
    this._appName = update.appLabel;
    this._isOverlayReverse = update.overlayIconStyle === OverlayIconStyle.REVERSE;
    this._appIcon = update.appIcon;
    this._overlayIcon = update.overlayIcon;
    this._smallIcon = update.smallIcon;
    this._clickAgent = update.wantAgent;
    this._appIndex = update.appIndex ?? 0;
    this.resetProperty();
    // 单通知
    if (update.isNormal()) {
      this._oriTitle = update.content?.contentTitle;
      this._oriContent = update.content?.contentText;
    }
    // 组通知
    if (update.isNormalGroup()) {
      let mainData = update.children?.[MAIN_INDEX];
      this._oriTitle = mainData?.content?.contentTitle;
      this._oriContent = mainData?.content?.contentText;
    }
    if (update.isLiveView()) {
      this._liveTypeCode = update.typeCode;
      this._liveType = update.card?.cardType;
      this._immerCardAuthLevel = update.card?.immersiveCardAuthLevel;
      // 系统实况
      if (update.card?.isSystemCard()) {
        this._oriTitle = update.card.title;
        this._oriContent = update.card.content;
        this._liveTimer = update.card.timer;
        this._isTimerInTitle = update.card.isTimerInTitle;
        this._sysProgress = update.card.progress;
        this._sysButtons = update.card.buttons;
      }
      // 三方实况
      if (update.card?.isOtherCard()) {
        this._oriTitle = update.card.fixedTitle;
        this._oriContent = '';
        update.card.fixedContent?.forEach((richText) => {
          if (richText.text) {
            this._oriContent += richText.text;
          }
        });
        this._otherExtensionType = update.card.extensionType;
        this._extWantAgent = update.card.extensionWantAgent;
        this._liveTimer = update.card.timer;
      }
      // 导航类型，取出导航转向图标
      if (update.card?.isNavigationCard()) {
        this._currNavDirectionIcon = update.card.layoutCurrentNavigationIcon;
        let iconType = update.card.layoutNavigationIconMimeType;
        this._isNavIconSvgOrPng = iconType === 'svg' || iconType === 'png';
      }
    }
    // 组通知类型
    if (update.isNormalGroup()) {
      this._childrenCount = update.children?.length ?? 0;
    }
  }

  /**
   * 复制数据
   *
   * @returns 新数据实例
   */
  public copy(): T {
    let copyData = this.createNewData();
    copyData._uid = `${copyData._uid}_${COPY_SUFFIX}`;
    copyData._dataGroupKey = `${copyData._dataGroupKey}_${COPY_SUFFIX}`;
    copyData._isCopyData = true;
    return copyData;
  }

  /**
   * 赋值实况业务注入器
   *
   * @param vmInjector 业务注入器
   */
  public setLiveVmInjector(vmInjector?: IImmersiveLiveVmInjector): void {
    this._liveVmInjector = vmInjector;
  }

  /**
   * 通知标记
   *
   * @returns 标记
   */
  public getNtfUid(): string {
    return this._uid;
  }

  /**
   * 隐私类型
   *
   * @returns 隐私类型
   */
  @Computed get privacyType(): ImmPrivacyType {
    let bundleName = this._oriData?.creatorBundleName;
    let isLiveNtf = false;
    let sysTypeCode = SysTypeCode.OTHER;
    if (this._oriData?.isLiveView()) {
      isLiveNtf = true;
      sysTypeCode = this._oriData.typeCode;
      // 情景模式包名
      if (this._oriData.isScenario()) {
        bundleName = ImmDataHelper.INTELLIGENT_BUNDLE_NAME;
      }
    }
    return this._immBindSt?.getPrivacyType({ bundleName: bundleName, appIndex: this._appIndex,
      isLiveNt: isLiveNtf, sysTypeCode: sysTypeCode });
  }

  /**
   * 计时器标题原文本
   *
   * @returns 原文本
   */
  protected getTimerOriTitle(): string | undefined {
    // 系统实况纯计时器，无文本拼接
    return this.isSysCard() ? undefined : this._oriTitle;
  }

  /**
   * 计时器副文本原文本
   *
   * @returns 原文本
   */
  protected getTimerOriContent(): string | undefined {
    // 系统实况纯计时器，无文本拼接
    return this.isSysCard() ? undefined : this._oriContent;
  }

  /**
   * phone类型计时器AOD场景
   *
   * @returns true phone类型计时器AOD场景
   */
  public isPhoneTimerAod(): boolean {
    return this.isSysPhone() && this.hasLiveTimer() && this.isAod();
  }

  /**
   * phone类型计时器AOD场景文本
   *
   * @returns AOD场景文本
   */
  public getPhoneAodText(): ResourceStr | undefined {
    // phone类型AOD场景计时器固定文本
    if (this.isPhoneTimerAod()) {
      return $r('app.string.aod_phone_timer_text');
    }
    return undefined;
  }

  /**
   * 是否计时器AOD场景
   *
   * @returns true计时器AOD场景
   */
  public isTimerAodScene(): boolean {
    return !this.isDataPrivacy() && this.hasLiveTimer() && this.isAod();
  }

  /**
   * 通用计时器AOD场景文本
   *
   * @returns AOD场景文本
   */
  public getComTimerAodText(): Resource | undefined {
    // 隐私场景，无计时器AOD固定文本
    if (!this.isTimerAodScene()) {
      return undefined;
    }
    if (this._liveTimer?.isCountdown) {
      return $r('app.string.aod_count_down_timer_text');
    }
    return $r('app.string.aod_timing_timer_text');
  }

  /**
   * 文本在AOD场景下居中显示
   *
   * @returns true 文本垂直居中
   */
  public isTextAodCenterShow(): boolean {
    let isCenterShow = this.isTimerAodScene();
    if (!isCenterShow) {
      return isCenterShow;
    }
    // 如果主副文本上无计时器，则无需AOD场景变形
    let oriText = this._isTimerInTitle ? this.getTimerOriTitle() : this.getTimerOriContent();
    return ImmersiveComHelper.testTimeRegx(oriText);
  }

  /**
   * 隐藏主标题
   * 主标题为计时器时，AOD下隐藏
   *
   * @returns true隐藏主标题
   */
  public isHideTitleText(): boolean {
    return this.isTextAodCenterShow() && this._isTimerInTitle;
  }

  /**
   * 隐藏副文本
   * 副文本为计时器时，AOD下隐藏
   *
   * @returns true隐藏副文本
   */
  public isHideContentText(): boolean {
    return this.isTextAodCenterShow() && !this._isTimerInTitle;
  }

  /**
   * 覆盖小图标对称样式（克隆应用图标）
   *
   * @returns true 克隆应用
   */
  public isOverlyReverse(): boolean {
    return this._isOverlayReverse;
  }

  /**
   * 导航类图标是否为svg或png
   *
   * @returns true svg/png
   */
  public isNavIconSvgOrPng(): boolean {
    return this._isNavIconSvgOrPng ?? false;
  }

  /**
   * 是否支持显示沉浸大卡
   *
   * @returns true沉浸大卡
   */
  public isSupportImmCard(): boolean {
    if (!this._oriData.isLiveView()) {
      return false;
    }
    if (this.isMediaCenter()) {
      return true;
    }
    // 隐藏内容时，不允许进入沉浸态
    if (this.isDataPrivacy()) {
      return false;
    }
    let card = this._oriData.card;
    if ((Boolean(card?.immersivePic) || Boolean(card?.immersiveWant)) && this.isHasImmersiveRight()) {
      return true;
    }
    return false;
  }

  /**
   * 是否对应数据类型
   *
   * @param type 目标类型
   * @returns true数据类型匹配
   */
  public isDataType(type: ImmDataType): boolean {
    return this.getImmDataType() === type;
  }

  /**
   * 是否为实况数据
   *
   * @returns true实况数据
   */
  public isLiveData(): boolean {
    return this._oriData.isLiveView();
  }

  /**
   * 是否为组通知数据
   *
   * @returns true组通知
   */
  public isGroupData(): boolean {
    return this._oriData.isNormalGroup();
  }

  /**
   * 是否为分身应用通知
   *
   * @returns true分身应用
   */
  public isCloneApp(): boolean {
    return this._appIndex > 0;
  }

  /**
   * 播控类型判断
   *
   * @returns true播控类型
   */
  public isMediaCenter(): boolean {
    return this._liveTypeCode === SysTypeCode.BROADCASTING_CENTER;
  }

  /**
   * 沉浸态权益管控，是否允许进沉浸态
   * 0:不支持进入沉浸态,1:支持进入沉浸态,2:DYNAMIC_IMAGE_RIGHT,3:支持进入沉浸态且支持交互
   *
   * @returns true允许进沉浸态
   */
  public isHasImmersiveRight(): boolean {
    return this._immerCardAuthLevel === 1 || this._immerCardAuthLevel === 3;
  }

  /**
   * 来电类型判断
   *
   * @returns true来电类型
   */
  public isSysPhone(): boolean {
    return this._liveTypeCode === SysTypeCode.PHONE;
  }

  /**
   * 系统实况
   *
   * @returns true系统实况
   */
  public isSysCard(): boolean {
    return this._liveType === LiveCardType.TYPE_SYSTEM;
  }

  /**
   * 三方实况是否存在辅助区点击动作
   *
   * @returns true辅助区可点击
   */
  public hasExtWant(): boolean {
    return Boolean(this._extWantAgent);
  }

  /**
   * 系统实况是否存在进度条
   *
   * @returns true系统进度条
   */
  public hasSysProgress(): boolean {
    return Boolean(this._sysProgress);
  }

  /**
   * 系统实况是否存在按钮
   *
   * @returns true系统按钮
   */
  public hasSysButton(): boolean {
    return !ArrayUtils.isEmpty(this._sysButtons);
  }

  /**
   * 系统/三方实况是否存在计时器
   *
   * @returns true计时器
   */
  public hasLiveTimer(): boolean {
    return this.isLiveData() && Boolean(this._liveTimer);
  }

  /**
   * 三方实况
   *
   * @returns
   */
  public isOtherCard(): boolean {
    return this._liveType !== undefined && !this.isSysCard();
  }

  /**
   * 三方实况是否存在扩展区
   *
   * @returns true三方扩展区
   */
  public hasOtherExtension(): boolean {
    return this.isOtherCard() && this._otherExtensionType !== LiveExtensionType.DEFAULT;
  }

  /**
   * 三方实况，无扩展区类型
   *
   * @returns true无扩展区
   */
  public isOtherNoLayoutCard(): boolean {
    return this._liveType === LiveCardType.NO_LAYOUT;
  }

  /**
   * 三方实况，左右文本类型
   *
   * @returns true左右文本
   */
  public isOtherFlightCard(): boolean {
    return this._liveType === LiveCardType.FLIGHT;
  }

  /**
   * 三方实况，导航类型
   *
   * @returns true导航类型
   */
  public isOtherNavCard(): boolean {
    return this._liveType === LiveCardType.NAVIGATION;
  }

  /**
   * 三方实况，强调文本类型
   *
   * @returns true强调文本
   */
  public isOtherPickupCard(): boolean {
    return this._liveType === LiveCardType.PICK_UP;
  }

  /**
   * 三方实况，进度可视化类型
   *
   * @returns true进度可视化
   */
  public isOtherProgressCard(): boolean {
    return this._liveType === LiveCardType.PROGRESS;
  }

  /**
   * 三方实况，赛事比分类型
   *
   * @returns true赛事比分
   */
  public isOtherScoreCard(): boolean {
    return this._liveType === LiveCardType.SCORE;
  }

  /**
   * 是否隐私场景
   *
   * @returns true隐私场景
   */
  public isDataPrivacy(): boolean {
    return this.isHideContent() || this.isAppLock();
  }

  /**
   * 隐藏通知内容
   *
   * @returns true隐藏内容
   */
  public isHideContent(): boolean {
    // 播控卡片无需隐藏内容
    return this.privacyType === ImmPrivacyType.PRIVACY_HIDE_CONTENT && !this.isMediaCenter();
  }

  /**
   * 应用锁
   *
   * @returns true应用锁
   */
  public isAppLock(): boolean {
    return this.privacyType === ImmPrivacyType.PRIVACY_APP_LOCK;
  }

  /**
   * 取值原通知数据
   *
   * @returns 原数据
   */
  public getOriData(): NotificationBase {
    return this._oriData;
  }

  /**
   * 系统/三方实况计时器数据
   *
   * @returns 计时器
   */
  public getLiveTimer(): LiveTimerModel | undefined {
    return this._liveTimer;
  }

  /**
   * 系统实况进度条数据
   *
   * @returns 进度条
   */
  public getSysProgress(): LiveProgressModel | undefined {
    return this._sysProgress;
  }

  /**
   * 系统实况按钮数据集
   *
   * @returns 按钮
   */
  public getSysButtons(): LiveButtonModel[] | undefined {
    return this._sysButtons;
  }

  /**
   * 取值通知唯一标识
   *
   * @returns 唯一标识
   */
  public getHashcode(): string {
    return this._hashcode;
  }

  /**
   * 取值分组标识
   *
   * @returns 分组标识
   */
  public getGroupKey(): string {
    return this._groupKey;
  }

  /**
   * 取值数据分组标识，仅用于数据列表管理标识
   *
   * @returns 数据分组标识
   */
  public getDataGroupKey(): string {
    return this._dataGroupKey;
  }

  /**
   * 是否为copy数据
   *
   * @returns true copy数据
   */
  public isCopyData(): boolean {
    return this._isCopyData;
  }

  /**
   * 取值应用名称
   *
   * @returns 应用名称
   */
  public getAppName(): string {
    return this._appName;
  }

  /**
   * 是否图标叠加显示
   *
   * @returns true叠加显示
   */
  public isShowOverlay(): boolean {
    // 克隆应用场景，保持小图标叠加
    if (this.isOverlyReverse()) {
      return true;
    }
    // 隐私场景，无叠加效果
    if (this.isDataPrivacy()) {
      return false;
    }
    // 存在overlay大图，则开启图标叠加
    return Boolean(this._overlayIcon);
  }

  /**
   * 取值叠加小图标
   *
   * @returns 叠加图标
   */
  public getSmallIcon(): image.PixelMap | ResourceStr | undefined {
    // 克隆应用场景，使用克隆应用小图标
    if (this.isOverlyReverse()) {
      return $r('app.media.app_icon_deliver');
    }
    // 隐私场景，保持应用图标
    let isOnlyApp = this.isDataPrivacy();
    return this._oriData.getAppIcon(isOnlyApp);
  }

  /**
   * 取值通用大图标
   *
   * @returns 大图标
   */
  public getLargeIcon(): image.PixelMap | ResourceStr | undefined {
    // 克隆应用场景，使用应用图标
    if (this.isOverlyReverse()) {
      return this._appIcon;
    }
    // 隐私场景，保持应用图标
    if (this.isDataPrivacy()) {
      return this._appIcon;
    }
    // 优先使用overlay图标
    return this.getOverlayIcon() ?? this.getSmallIcon();
  }

  /**
   * 图标颜色过滤
   * 导航方向图标
   *
   * @returns true支持颜色过滤
   */
  public isSupportColorFilter(): boolean {
    // 非导航图标，不支持颜色过滤
    if (this.getLargeIcon() !== this._currNavDirectionIcon) {
      return false;
    }
    return this.isNavIconSvgOrPng();
  }

  /**
   * 叠加场景大图
   *
   * @returns 大图
   */
  private getOverlayIcon(): image.PixelMap | undefined {
    // 导航场景，转向图标
    if (this.isOtherNavCard() && this._currNavDirectionIcon) {
      return this._currNavDirectionIcon;
    }
    // overlay图标
    return this._overlayIcon;
  }
}