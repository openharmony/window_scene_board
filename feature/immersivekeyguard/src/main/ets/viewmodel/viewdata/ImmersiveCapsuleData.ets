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

import {
  BaseConstants,
  ImmersiveCapsuleType,
  ImmersiveShowType,
  LiveBaseTemplate,
  LiveButtonArray,
  LiveExtendType,
  LiveNavigationTemplate,
  LiveOtherExtendData,
  LiveProgressData,
  LiveSystemTemplate,
  LiveTimerData,
  LiveType,
  OverlayIconStyle,
  SysTypeCode,
} from '@ohos/systemuicommon';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import type { LiveViewData } from '@ohos/systemuicommon';
import type { ICapsuleData } from '@ohos/systemuicommon';
import image from '@ohos.multimedia.image';
import { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import { ImmersiveConstants } from '../../common/ImmersiveConstants';
import { CapsuleRemindType, LiveViewCommonConstants } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import {
  TimeTextStyle
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/interface/TimeTextStyle';
import { LiveStyle } from '@ohos/systemuicommon/src/main/ets/live/constants/LiveStyle';

const MAIN_INDEX = 0; // 组通知索引
const SECONDARY_INDEX = 1; // 组通知索引
const timeTemplateReg = /\$\{placeholder.timer\}/g;
const HEALTH = 'com.ohos.health';

const TAG = 'ImmersiveCapsuleData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 胶囊非UI绑定数据处理
 */
class CapsuleInnerData {
  public hashCode?: string; // 通知唯一标示
  public groupKey?: string; // 分组标示
  public title?: string; // 标题
  public content?: string; // 内容
  public children: CapsuleInnerData[] = []; // 通知成组
}

/**
 * 沉浸式锁屏胶囊数据模型
 */
@Observed
export class ImmersiveCapsuleData implements ICapsuleData {
  private innerData: CapsuleInnerData = new CapsuleInnerData(); // 非UI绑定数据
  public capsuleType: ImmersiveCapsuleType = ImmersiveCapsuleType.NORMAL; // 沉浸式胶囊类型，默认普通样式
  public overlayIcon?: image.PixelMap; // overlay大图标
  public overlayIconStyle?: OverlayIconStyle; // overlay图标样式
  public smallIcon?: image.PixelMap | DrawableDescriptor | string; // 小图标，替代应用图标
  public appIcon?: image.PixelMap | DrawableDescriptor | string; // 应用图标
  public appName?: string; // 应用名称
  private bundleName?: string; // 应用包名
  private appIndex?: number; // 分身应用index
  public mainTitle?: string; // 主标题
  public secondaryTitle?: string; // 次标题
  public mainContent?: string; // 主内容
  public secondaryContent?: string; // 次内容
  public childrenCount: number = 0; // 通知个数，默认自己
  public isHideContent: boolean = false; // 是否隐藏通知内容
  private isAppLocked?: boolean = false; // 应用是否上锁
  public liveType: LiveType = LiveType.NO_LAYOUT; // 实况样式类型
  private sysTypeCode: SysTypeCode = SysTypeCode.OTHER; // 系统实况类型码
  public liveTimer?: LiveTimerData; // 计时器文本数据
  public liveBaseTemplate?: LiveBaseTemplate; // 实况的模板数据
  public templateTime?: LiveTimerData; // 主副文本存在计时占位字段时使用
  public liveProgress?: LiveProgressData; // 辅助区进度条数据
  private liveButton?: LiveButtonArray; // 辅助区按钮数据
  public liveOther?: LiveOtherExtendData; // 辅助区三方数据
  public liveView?: LiveViewData; // 实况原数据
  private currNavDirectionIcon?: image.PixelMap; //导航左侧大图
  private layoutNavigationIconMimeType?: string; // 导航左侧大图类型
  public remindType?: CapsuleRemindType; // 胶囊更新提醒方式
  private realCounts: string = ''; // 通知条数
  private timeTitleStyle: TimeTextStyle =
    new TimeTextStyle(ImmersiveConstants.TITLE_TIMER_HEIGHT, ImmersiveConstants.TITLE_TIMER_FONT_SIZE);
  private timeContentStyle: TimeTextStyle =
    new TimeTextStyle(ImmersiveConstants.CONTENT_TIMER_HEIGHT, ImmersiveConstants.CONTENT_TIMER_FONT_SIZE);
  private showType: ImmersiveShowType = ImmersiveShowType.SHOW_CAPSULE; // 数据可显示类型

  /**
   * 是否是进度类型
   */
  private isProgress?: boolean;

  /**
   * 胶囊数据是否为实况类型
   *
   * @returns true实况类型
   */
  isLiveCapsule(): boolean {
    return this.capsuleType === ImmersiveCapsuleType.LIVE_VIEW;
  }

  /**
   * 是否系统实况
   *
   * @returns true系统实况
   */
  isSysLiveType(): boolean {
    return this.liveType === LiveType.TYPE_SYSTEM;
  }

  /**
   * 是否为播控类型
   *
   * @returns true播控
   */
  isMediaPlay(): boolean {
    return this.isLiveCapsule() && this.sysTypeCode === SysTypeCode.BROADCASTING_CENTER;
  }

  /**
   * 是否为进度类型
   */
  isProgressType(): boolean {
    return this.isProgress === true;
  }

  /**
   * 是否显示沉浸卡片
   *
   * @returns boolean
   */
  shouldShowInImmersiveCard(): boolean {
    if (this.isHideContent) {
      return false;
    }
    return (this.showType & ImmersiveShowType.SHOW_CARD) !== 0;
  }

  /**
   * 是否存在图标叠加场景
   *
   * @returns true叠加
   */
  hasOverlayIcon(): boolean {
    if (this.overlayIconStyle === OverlayIconStyle.REVERSE) {
      return true;
    }
    if (this.isHideContent) {
      return false;
    }
    return !CommonUtils.isInvalid(this.overlayIcon);
  }

  /**
   * 大图标
   *
   * @returns 大图标
   */
  getLargeIcon(): image.PixelMap | string | DrawableDescriptor | undefined {
    if (this.overlayIconStyle === OverlayIconStyle.REVERSE) {
      return this.appIcon;
    }
    if (this.isHideContent) {
      return this.isAppLocked && !this.isLiveCapsule() ? this.appIcon : this.getSmallIcon();
    }
    if (this.liveType === LiveType.NAVIGATION) {
      return this.currNavDirectionIcon;
    }
    return this.hasOverlayIcon() ? this.overlayIcon : this.getSmallIcon(); // 优先overlay，其次默认图标
  }

  /**
   * 大图的颜色过滤器
   *
   * @param isAod AOD场景
   * @returns 颜色过滤器
   */
  getLargeColorFilter(isAod?: boolean): ColorFilter | undefined {
    // 非AOD场景，不涉及
    if (!isAod) {
      return undefined;
    }
    // 图片类型不支持反色
    if (this.layoutNavigationIconMimeType !== 'svg' && this.layoutNavigationIconMimeType !== 'png') {
      return undefined;
    }
    // 导航图片反色
    if (this.getLargeIcon() !== this.currNavDirectionIcon) {
      return undefined;
    }
    return LiveStyle.WHITE_COLOR_FILTER;
  }

  /**
   * 叠加小图标
   *
   * @returns 小图标
   */
  getSmallIcon(): image.PixelMap | string | DrawableDescriptor | undefined {
    if (CommonUtils.isInvalid(this.smallIcon) && CommonUtils.isInvalid(this.appIcon)) {
      log.showWarn('capsule icon is invalid');
    }
    return CommonUtils.isInvalid(this.smallIcon) ? this.appIcon : this.smallIcon; // 优先small，其次应用图标
  }

  /**
   * 进度条
   *
   * @returns true进度条
   */
  hasProgress(): boolean {
    return this.isLiveCapsule() && this.isSysLiveType() && !CommonUtils.isInvalid(this.liveProgress);
  }

  /**
   * 按钮
   *
   * @returns true按钮
   */
  hasButton(): boolean {
    return this.isLiveCapsule() && this.isSysLiveType() && !ArrayUtils.isEmpty(this.liveButton);
  }

  /**
   * 获取按钮数据
   *
   * @returns 多按钮
   */
  getButtonData(count: number = 4): LiveButtonArray | undefined {
    if (this.hasProgress()) { // 存在进度条，则减少一个按钮
      count--;
    }
    return this.liveButton?.getButtonDataByPriority(count);
  }

  /**
   * 三方辅助区
   *
   * @returns 三方
   */
  hasOther(): boolean {
    return this.isLiveCapsule() && !this.isSysLiveType() && !CommonUtils.isInvalid(this.liveOther);
  }

  /**
   * 是否计时器
   *
   * @returns true计时器
   */
  hasTimer(): boolean {
    return this.isLiveCapsule() && !CommonUtils.isInvalid(this.liveTimer);
  }

  /**
   * 是否组通知样式显示
   * 加锁应用只展示单条通知
   * @returns true组通知
   */
  isShowGroupStyle(): boolean {
    return !this.isLiveCapsule() && !this.isHideContent && this.childrenCount > BaseConstants.MAX_VALUE;
  }

  /**
   * 是否是强提醒通知
   *
   * @returns true 强提醒通知
   */
  isCapsuleRemind(): boolean {
    if (!this.remindType) {
      return false;
    }
    return this.remindType === CapsuleRemindType.FLIP || this.remindType === CapsuleRemindType.EXPAND;
  }

  /**
   * 非组通知样式标题
   *
   * @returns 标题
   */
  getTitle(timer?: LiveTimerData, bundleName?: string, isAod?: boolean): string {
    let res = '';
    if (this.isAppLocked || this.isHideContent) {
      // 如果应用加锁, 则标题只展示应用名称
      if (this.appName) {
        res = this.appName;
      } else {
        log.showWarn(`isHideContent getTitle fail, appName: ${this.appName}`);
      }
    } else if (this.capsuleType === ImmersiveCapsuleType.NORMAL || this.liveBaseTemplate === undefined) {
      res = this.mainTitle ?? '';
    } else {
      res = this.liveBaseTemplate?.transformTimerText(this.mainTitle, timer) ?? '';
    }
    if (bundleName === HEALTH && isAod && typeof res === 'string') {
      res = res.replace(LiveViewCommonConstants.NUM_REGX, LiveViewCommonConstants.NUM_FUZZ);
    }
    // 通知类型为含有计时器的通话类型，AOD下显示为正在通话
    if (this.sysTypeCode === SysTypeCode.PHONE && isAod && this.hasTimer()) {
      res = ResUtils.getInnerString($r('app.string.aod_phone_timer_text'));
    }
    return res;
  }

  /**
   * 非组通知样式副标题
   *
   * @returns 标题
   */
  getContent(timer?: LiveTimerData, bundleName?: string, isAod?: boolean): ResourceStr {
    let res: ResourceStr = '';
    if (this.isHideContent) {
        let count = this?.childrenCount ?? BaseConstants.MAX_VALUE;
        ResUtils.getInnerPlural(this.getContentResource(), count === 0 ? 1 : count).then((counts) => {
          this.realCounts = counts;
          res = this.realCounts;
        });
        res = this.realCounts;
    } else if (this.capsuleType === ImmersiveCapsuleType.NORMAL || this.liveBaseTemplate === undefined) {
      res = this.mainContent ?? '';
    } else {
      res = this.liveBaseTemplate?.transformTimerText(this.mainContent, timer) ?? '';
    }
    if (bundleName === HEALTH && isAod && typeof res === 'string') {
      res = res.replace(LiveViewCommonConstants.NUM_REGX, LiveViewCommonConstants.NUM_FUZZ);
    }
    // 通知类型为含有计时器的通话类型，AOD下显示为正在通话
    if (this.sysTypeCode === SysTypeCode.PHONE && isAod && this.hasTimer()) {
      res = $r('app.string.aod_phone_timer_text');
    }
    return res;
  }

  /**
   * 创建组通知
   */
  createGroup(): void {
    ArrayUtils.clearArr(this.innerData.children);
    this.innerData.children.push(this.innerData);
    this.refreshChildrenCount();
  }

  /**
   * 添加子通知数据到分组
   *
   * @param newData 子通知
   */
  addChildData(newData: ImmersiveCapsuleData): void {
    this.innerData.children.push(newData.innerData);
    this.refreshChildrenCount();
  }

  /**
   * 删除分组数据
   */
  deleteGroup(): void {
    ArrayUtils.clearArr(this.innerData.children);
    this.refreshChildrenCount();
  }

  /**
   * 显示类型
   *
   * @param showType 显示类型
   */
  setShowType(showType: ImmersiveShowType): void {
    this.showType = showType;
  }

  /**
   * 唯一标示
   *
   * @param hashCode 标识
   */
  setHashCode(hashCode?: string): void {
    this.innerData.hashCode = hashCode;
  }

  /**
   * 分组标示
   *
   * @param groupKey 分组标示
   */
  setGroupKey(groupKey: string): void {
    this.innerData.groupKey = groupKey;
  }

  /**
   * 标题文本
   *
   * @param title 标题
   * @param forceRefresh 刷新UI
   */
  setTitle(title?: string, forceRefresh?: boolean): void {
    this.innerData.title = title;
    if (forceRefresh) {
      this.updateTitleContent();
    }
  }

  /**
   * 内容文本
   *
   * @param content 内容
   * @param forceRefresh 刷新UI
   */
  setContent(content?: string, forceRefresh?: boolean): void {
    this.innerData.content = content;
    if (forceRefresh) {
      this.updateTitleContent();
    }
  }

  /**
   * 应用图标
   *
   * @param appIcon 图标
   * @param forceRefresh 强制刷新
   */
  setAppIcon(appIcon?: image.PixelMap | string | DrawableDescriptor, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(appIcon)) {
      this.appIcon = appIcon;
    }
  }

  /**
   * 应用名称
   *
   * @param appName 应用名
   * @param forceRefresh 强制刷新
   */
  setAppName(appName?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(appName)) {
      this.appName = appName;
    }
  }
  
  /**
   * 应用包名
   * 
   * @param bundleName
   */
  public setBundleName(bundleName?: string): void {
    if (bundleName === undefined) {
      log.showWarn(`setBundleName undefined`);
    }
    this.bundleName = bundleName;
  }

  /**
   * 分身应用appIndex
   * 
   * @param appIndex
   */
  public setAppIndex(appIndex?: number): void {
    if (appIndex === undefined) {
      log.showWarn(`setAppIndex undefined`);
    }
    this.appIndex = appIndex;
  }

  /**
   * 设置通知是否隐藏
   *
   * @param isHideContent 是否隐藏
   */
  setNtfHide(isHideContent: boolean): void {
    this.isHideContent = isHideContent;
  }

  /**
   * 设置当前应用是否处于应用锁加锁状态
   *
   * @param isAppLocked 是否处于加锁状态
   */
  setAppLocked(isAppLocked?: boolean): void {
    this.isAppLocked = isAppLocked;
  }

  /**
   * 设置胶囊类型
   *
   * @param capsuleType 胶囊类型
   * @param forceRefresh 是否强制刷新
   */
  setCapsuleType(capsuleType: ImmersiveCapsuleType, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(capsuleType)) {
      this.capsuleType = capsuleType;
    }
  }

  /**
   * 设置胶囊提醒类型
   *
   * @param type 胶囊提醒类型
   */
  setCapRemindType(type?: CapsuleRemindType, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(type)) {
      this.remindType = type;
    }
  }

  /**
   * 设置overlay大图
   *
   * @param overlayIcon overlay大图
   * @param forceRefresh 是否强制刷新
   */
  setOverlayIcon(overlayIcon?: image.PixelMap, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(overlayIcon)) {
      this.overlayIcon = overlayIcon;
    }
  }

  /**
   * 设置overlayIcon样式
   *
   * @param overlayIconStyle 图标样式(0: 圆形, 1: 方形, 2: 样式反转)
   * @param forceRefresh 强制刷新
   */
  setOverlayIconStyle(overlayIconStyle: OverlayIconStyle, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(overlayIconStyle)) {
      this.overlayIconStyle = overlayIconStyle;
    }
  }

  setSmallIcon(smallIcon?: image.PixelMap, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(smallIcon)) {
      this.smallIcon = smallIcon;
    }
  }

  /**
   * 刷新分组个数
   */
  refreshChildrenCount(): void {
    let count = ArrayUtils.getSize(this.innerData.children);
    if (this.childrenCount !== count) {
      this.childrenCount = count;
      this.updateTitleContent();
    }
  }

  /**
   * 设置实况数据
   *
   * @param liveTemplate 实况模板数据
   * @param forceRefresh 是否强制刷新
   */
  setLiveView(liveView?: LiveViewData, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(liveView)) {
      this.liveView = liveView;
      this.updateLiveCapsule();
      this.updateTitleContent();
    }
  }

  /**
   * 设置是否是进度类型
   *
   * @param isProgress 是否是进度类型
   */
  setProgressType(isProgress?: boolean): void {
    this.isProgress = isProgress;
  }

  /**
   * 标题上是否存在计时器
   *
   * @returns true 标题计时器
   */
  isTimerInTitle(): boolean {
    let timer = this.liveView?.getTimerData();
    if (CommonUtils.isInvalid(timer)) {
      return false;
    }
    return timer?.isInTitle ?? false;
  }

  /**
   * 内容上是否存在计时器
   *
   * @returns true 内容计时器
   */
  isTimerInContent(): boolean {
    let timer = this.liveView?.getTimerData();
    if (CommonUtils.isInvalid(timer)) {
      return false;
    }
    return !(timer?.isInTitle ?? false);
  }

  getTimeTextStyle(isInContent: boolean): TimeTextStyle {
    return (this.isTimerInContent() && isInContent) ? this.timeContentStyle : this.timeTitleStyle;
  }

  /**
   * 获取应用标识，用于获取应用上锁状态
   * @returns string tag
   */
  getBundleIdxTag(): string {
    return `${this.bundleName}_${this.appIndex}`;
  }

  /**
   * 实况样式数据刷新
   *
   * @param liveView 实况数据
   */
  private updateLiveCapsule(): void {
    let liveView = this.liveView;
    if (liveView) {
      this.liveType = liveView.liveType;
      this.sysTypeCode = liveView.sysTypeCode;
      this.liveProgress = liveView.getProgressData();
      this.liveButton = liveView.getButtonData();
      let template = liveView.template as LiveBaseTemplate;
      this.liveTimer = liveView?.getTimerData();
      this.liveBaseTemplate = template;
      this.templateTime = liveView?.getTemplateTimer();
      this.liveOther = template?.getExtendData(LiveExtendType.TYPE_OTHER_EXTEND) as LiveOtherExtendData;
      this.innerData.title = template.title ?? '';
      this.innerData.content = template.content ?? template.getContentFromRichContent() ?? '';
      if (this.isSysLiveType()) {
        this.overlayIcon = (template as LiveSystemTemplate)?.overlayIcon;
      }
      if (this.liveType === LiveType.NAVIGATION) {
        let navTemplate = template as LiveNavigationTemplate;
        this.updateNavDirectionIcon(navTemplate);
        this.layoutNavigationIconMimeType = navTemplate?.layoutNavigationIconMimeType;
      }
    }
  }

  private updateNavDirectionIcon(template?: LiveNavigationTemplate): void {
    if (!template) {
      log.error('template is invalid.');
      return;
    }
    if (template.currNavDirectionIcon) {
      this.currNavDirectionIcon = template.currNavDirectionIcon;
      return;
    }
    if (CommonUtils.isInvalid(template.currNavDirectionIconRes)) {
      log.error('template icon res is invalid.');
      return;
    }
  }

  /**
   * 标题内容刷新
   */
  private updateTitleContent(): void {
    if (this.isLiveCapsule()) { // 实况样式
      this.mainTitle = this.innerData.title;
      this.mainContent = this.innerData.content;
      this.secondaryTitle = undefined;
      this.secondaryContent = undefined;
    } else { // 普通样式
      this.mainTitle = this.innerData.title;
      this.mainContent = this.innerData.content;
      this.secondaryTitle = this.innerData.children?.[SECONDARY_INDEX]?.title;
      this.secondaryContent = this.innerData.children?.[SECONDARY_INDEX]?.content;
    }
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    if (!(other instanceof ImmersiveCapsuleData)) {
      return;
    }
    let otherCapsule = other as ImmersiveCapsuleData;
    this.setCapsuleType(otherCapsule.capsuleType, forceRefresh);
    this.setCapRemindType(otherCapsule.remindType, forceRefresh);
    this.setOverlayIcon(otherCapsule.overlayIcon, forceRefresh);
    this.setNtfHide(otherCapsule.isHideContent);
    this.innerData.children = otherCapsule.innerData.children;
    this.smallIcon = otherCapsule.smallIcon;
    this.setTitle(otherCapsule.innerData.title, false);
    this.setContent(otherCapsule.innerData.content, false);
    this.setLiveView(otherCapsule.liveView, forceRefresh);
    this.refreshChildrenCount();
  }

  toString(): string {
    let str: string = `capsuleType: ${this.capsuleType}, `;
    if (this.isLiveCapsule()) {
      str += this.liveView?.template?.toString();
    } else {
      str += `hashcode: ${this.innerData.hashCode}, isHide: ${this.isHideContent},
        title: ${this.getTitle()}, content: ${this.getContent()}`;
    }
    return str;
  }

  private getContentResource(): Resource {
    return this.capsuleType === ImmersiveCapsuleType.LIVE_VIEW ? $r('app.plural.live_hide_content') :
    $r('app.plural.ntf_hide_content_tip');
  }
}
