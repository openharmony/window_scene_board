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
import type image from '@ohos.multimedia.image';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseExtendProperty } from '../../../base/common/info/BaseExtendProperty';
import type { ILiveTemplateData } from '../../common/ILiveTemplateData';
import { LiveExtendType, LivePositionName, LiveViewCommonConstants } from '../../common/LiveConstants';
import { LivePropertyName, LiveType, LiveUsageScene } from '../../common/LiveConstants';
import { NotificationWantAgentInfo } from '../../../model/NotificationAppInfo';
import type { WantAgent } from '@ohos.wantAgent';
import { PropertyHelper } from '../../../base/common/interface/IPropertyExtended';
import type { ILiveExtendData } from '../../common/ILiveExtendData';
import type { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import { LiveTimerData } from '../extend/LiveTimerData';
import { LiveAccessibilityUtil } from '../../common/liveAccessibilityUtil';
import { OverlayIconStyle } from '../../../model/NotificationContent';

const timeTemplateReg = /\$\{placeholder.timer\}/g;
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveBaseTemplate');

/**
 * 富文本
 */
@Observed
export class RichText {
  /**
   * 富文本内容
   */
  text?: string;

  /**
   * 富文本原颜色
   */
  oriTextColor?: string;

  /**
   * 富文本当前显示颜色
   * 浅色模式允许富文本，深色模式需统一颜色
   */
  currentTextColor?: string;

  /**
   * 获取当前富文本颜色
   *
   * @returns 富文本颜色
   */
  getCurrentTextColor(): string {
    // 默认使用原颜色
    if (CommonUtils.isInvalid(this.currentTextColor)) {
      return this.oriTextColor;
    }
    return this.currentTextColor;
  }

  toString(): string {
    return 'text:' + this.text +
      ', oriTextColor:' + this.oriTextColor +
      ', currentTextColor:' + this.currentTextColor;
  }
}

/**
 * 实况卡片基础模板
 */
@Observed
export class LiveBaseTemplate extends BaseExtendProperty implements ILiveTemplateData {
  isInstallMetaSer: boolean = true;

  uninstallMetaSerBundleName: string = '';

  /**
   * 卡片标题
   */
  title?: string;

  isTitleLine?: string;

  /**
   * 卡片副文本
   */
  content?: string;

  /**
   * 卡片副文本(富文本)
   */
  richContent?: RichText[];

  /**
   * 应用图标，系统应用允许被smallIcon替代
   * 内部字段，加载application图标
   */
  appIcon?: string | image.PixelMap | DrawableDescriptor;

  /**
   * 应用图标base64资源串
   * 内部字段，加载application图标
   */
  appIconRes?: string | DrawableDescriptor;

  /**
   * 通知小图标
   */
  smallIcon?: image.PixelMap;

  /**
   * 通知图标样式
   * 0: 圆形; 1: 方形; 2: 样式反转
   */
  overlayIconStyle?: OverlayIconStyle;

  /**
   * 消息点击行为
   */
  wantAgent?: WantAgent;

  /**
   * 消息点击行为信息
   */
  wantAgentInfo?: NotificationWantAgentInfo;

  /**
   * 扩展数据类型集，默认无扩展数据
   * 此处主要用于扩展卡片模板辅助区数据
   */
  extendType: LiveExtendType = 0;

  /**
   * 倒计时模板的特有字段
   */
  timer: LiveTimerData = new LiveTimerData();

  /**
   * 是否是时间模板的实况通知
   */
  isTimeTemplate: boolean = false;

  /**
   * 扩展数据类型与位置名称对应关系
   */
  protected extendPosition: Map<LiveExtendType, LivePositionName> = new Map();

  getContentFromRichContent(): string {
    let res = '';
    for (let item of this.richContent) {
      res += item.text;
    }
    return res;
  }

  /**
   * 复写接口ILiveTemplateData
   *
   * @returns 实况类型
   */
  getLiveType(): LiveType {
    return LiveType.NO_LAYOUT;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    if (!(other instanceof LiveBaseTemplate)) {
      return;
    }
    let otherTemplate = other as LiveBaseTemplate;
    this.setTitle(otherTemplate.title, forceRefresh);
    this.setContent(otherTemplate.content, forceRefresh);
    this.setRichContent(otherTemplate.richContent, forceRefresh);
    this.setAppIcon(otherTemplate.appIcon, forceRefresh);
    this.setAppIconRes(otherTemplate.appIconRes, forceRefresh);
    this.setSmallIcon(otherTemplate.smallIcon, forceRefresh);
    this.setOverlayIconStyle(otherTemplate.overlayIconStyle, forceRefresh);
    this.setWantAgent(otherTemplate.wantAgent, true);
    this.wantAgentInfo = other.wantAgentInfo;
    this.clearText();

    // 扩展数据，计时器、进度、按钮
    this.extendPosition.forEach((position, extendType) => {
      let extendData = this.getExtendData(extendType);
      let newData = otherTemplate.getExtendData(extendType);
      if (CommonUtils.isInvalid(newData)) {
        this.setExtendData(extendType, undefined, true);
      }
      if (forceRefresh || CommonUtils.isInvalid(extendData)) {
        this.setExtendData(extendType, newData, forceRefresh);
      } else {
        extendData?.update(newData, forceRefresh);
      }
    });
  }

  /**
   * 设置标题
   *
   * @param title 标题文本
   * @param forceRefresh 是否强制刷新
   */
  setTitle(title?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(title)) {
      this.title = title;
    }
  }

  /**
   * 设置副文本的富文本
   *
   * @param richContent 富文本
   */
  setRichContent(richContent?: RichText[], forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(richContent)) {
      this.richContent = richContent;
    }
  }

  /**
   * 设置副文本
   *
   * @param content 副文本
   * @param forceRefresh 是否强制刷新
   */
  setContent(content?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(content)) {
      this.content = content;
    }
  }

  /**
   * 设置appIcon
   *
   * @param appIcon 图标
   * @param forceRefresh 是否强制刷新
   */
  setAppIcon(appIcon?: string | image.PixelMap | DrawableDescriptor, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(appIcon)) {
      this.appIcon = appIcon;
    }
  }

  /**
   * 设置appIconRes
   *
   * @param appIconRes 图标
   * @param forceRefresh 是否强制刷新
   */
  setAppIconRes(appIconRes?: string | DrawableDescriptor, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(appIconRes)) {
      this.appIconRes = appIconRes;
    }
  }

  /**
   * 设置smallIcon
   *
   * @param smallIcon 通知小图标
   * @param forceRefresh 强制刷新
   */
  setSmallIcon(smallIcon: image.PixelMap, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(smallIcon)) {
      this.smallIcon = smallIcon;
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

  /**
   *  设置clickAction
   *
   * @param wantAgent 点击行为
   * @param forceRefresh 是否强制刷新
   */
  setWantAgent(wantAgent?: WantAgent, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(wantAgent)) {
      this.wantAgent = wantAgent;
    }
  }


  /**
   * 设置判断是否是未安装元服务实况消息, flag=1表示该元服务已经安装，flag=0表示该元服务未安装
   * @param forceRefresh 是否强制刷新
   */
  setUninstallMetaSer(installMetaServiceFlag: number): void {
    this.isInstallMetaSer = installMetaServiceFlag === 1 ? true : false;
  }


  /**
   * 获取未安装元服务实况应用名称
   * @param forceRefresh 是否强制刷新
   */
  setUninstallMetaSerBoundName(uninstallMetaSerBundleName?: string): void {
    if (!CommonUtils.isInvalid(uninstallMetaSerBundleName)) {
      this.uninstallMetaSerBundleName = uninstallMetaSerBundleName;
    }
  }

  /**
   * 替换副文本的富文本颜色
   *
   * @param color 替代颜色
   */
  replaceRichContentColor(color?: string): void {
    this.replaceRichTextColor(this.richContent, color);
  }

  /**
   * 获取应用图标
   *
   * @returns 应用图标
   */
  getAppIcon(): image.PixelMap | string | DrawableDescriptor {
    if (!CommonUtils.isInvalid(this.appIcon)) {
      return this.appIcon;
    }
    log.showWarn(`use appIconRes isInvalid ${CommonUtils.isInvalid(this.appIconRes)}`);
    return this.appIconRes;
  }

  getSmallIcon(): image.PixelMap | undefined {
    if (this.getLiveType() === LiveType.TYPE_SYSTEM &&
      (CommonUtils.isInvalid(this.smallIcon) || !this.smallIcon?.getPixelBytesNumber())) {
      log.showWarn(`smallIcon is invalid`);
    }
    return this.smallIcon;
  }

  getOverlayIconStyle(): OverlayIconStyle {
    return this.overlayIconStyle;
  }

  /**
   * 当前是否存在某种扩展数据
   *
   * @param extendType 扩展数据类型
   * @returns true存在该扩展数据
   */
  hasExtendData(extendType: LiveExtendType): boolean {
    return (this.extendType & extendType) === extendType;
  }

  /**
   * 获取扩展数据
   *
   * @param extendType 扩展数据类型
   * @returns 扩展数据
   */
  getExtendData(extendType: LiveExtendType): ILiveExtendData | undefined {
    if (!this.hasExtendData(extendType)) {
      return undefined;
    }
    let key = this.getExtendDataPropertyKey(extendType);
    let data = PropertyHelper.getPropertyValue(this, key);
    if (CommonUtils.isInvalid(data)) {
      return undefined;
    }
    return data as ILiveExtendData;
  }

  /**
   * 设置扩展数据
   *
   * @param extendType 扩展数据类型
   * @param data 扩展数据
   */
  setExtendData(extendType: LiveExtendType, data?: ILiveExtendData, forceRefresh?: boolean): void {
    // 不支持限制内的扩展数据不允许设置
    if (!this.extendPosition.has(extendType)) {
      return;
    }
    let key = this.getExtendDataPropertyKey(extendType);
    if (forceRefresh || !CommonUtils.isInvalid(data)) {
      PropertyHelper.setPropertyValue(this, key, data);
    }

    // 存在数据则加入类型
    if (!CommonUtils.isInvalid(PropertyHelper.getPropertyValue(this, key))) {
      this.extendType |= extendType;
    } else {
      this.extendType &= ~extendType;
    }
  }

  getTitleText(text: string, timer: LiveTimerData): string {
    if (this.isTitleLine !== undefined) {
      this.isTitleLine = this.transformTimerText(text, timer);
      return this.isTitleLine;
    }
    this.isTitleLine = this.transformTimerText(text, timer);
    return this.isTitleLine;
  }

  /**
   * 替换富文本颜色
   *
   * @param richText 富文本集
   * @param replaceColor 替代颜色
   */
  protected replaceRichTextColor(richText?: RichText[], replaceColor?: string): void {
    if (ArrayUtils.isEmpty(richText)) {
      return;
    }
    richText.forEach((text) => {
      text.currentTextColor = replaceColor;
    });
  }

  /**
   * 获取扩展数据的属性key
   *
   * @param extendType 扩展数据类型
   * @returns 属性key
   */
  private getExtendDataPropertyKey(extendType: LiveExtendType): string {
    return PropertyHelper.getPropertyKey(LivePropertyName.EXTEND_DATA, LiveUsageScene.SCENE_LIVE_NTF,
      this.extendPosition.get(extendType));
  }

  private clearText(): void {
    this.isTitleLine = undefined;
  }

  /**
   * 将文本转换为带倒计时文本
   */
  transformTimerText(text: string, timer: LiveTimerData): string {
    if (!this.isTimeTemplate) {
      return text.replace(timeTemplateReg, '');
    }
    const timeString = LiveViewCommonConstants.formatDate(timer?.initialTime, new Date(), timer?.isCountDown);
    return text.replace(timeTemplateReg, timeString);
  }

  /**
   * 将文本转换为带倒计时文本
   */
  transformTimerAccessibilityText(text: string, timer: LiveTimerData): string {
    if (!this.isTimeTemplate || !LiveAccessibilityUtil.isAccessibilityMode()) {
      return text;
    }
    return text.replace(timeTemplateReg, LiveAccessibilityUtil.getTImeAccessibilityText(timer));
  }
}