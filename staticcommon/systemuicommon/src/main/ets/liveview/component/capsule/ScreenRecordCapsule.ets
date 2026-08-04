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

import { CapsuleListState } from '../../info/capsule/CapsuleListState';
import { LiveCapsuleData } from '../../data/capsule/LiveCapsuleData';
import { LiveTimerData } from '../../data/extend/LiveTimerData';
import { capsuleStateMgr } from '../../CapsuleManager';
import CapsuleMarquee, { CapsuleMarqueeContent } from './CapsuleMarquee';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { LiveViewCapsuleStyle } from '../../common/LiveViewCapsuleStyle';
import { ImmersiveAodStyle } from '../../../immersivekeyguardcommon/base/interface/ImmersiveAodStyle';
import { immersiveKgMgr } from '../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { LiveViewData } from '../../data/LiveViewData';
import { LiveViewCommonConstants } from '../../common/LiveConstants';
import { bannerMgr } from '../../../banner/phone/BannerManager';
import { BannerPanelType } from '../../../banner/common/info/BannerState';
import { inspector, componentUtils } from '@kit.ArkUI';
import { CapsuleIcon } from './CapsuleIcon';
import { LiveViewSysEventUtil } from '../../common/LiveViewSysEventUtil';
import { LiveAccessibilityUtil } from '../../common/liveAccessibilityUtil';

const TAG = 'ScreenRecordCapsule';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 录屏胶囊
 */
@Component
export default struct ScreenRecordCapsule {
  @State capsuleListState: CapsuleListState = capsuleStateMgr.getCapsuleState();
  /**
   * AOD显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(true);
  @ObjectLink capsuleData: LiveCapsuleData;
  @ObjectLink timeData: LiveTimerData;
  @Prop textOpacity: number;
  @Prop iconOpacity: number;
  @Prop marqueeEnabled: boolean;
  @Prop fontColor: string = LiveViewCapsuleStyle.CAPSULE_TEXT_COLOR;
  @Prop isAnimation: boolean = false;
  @Prop shouldHideContent: boolean = false;
  @Prop isLockScreen: boolean = false;
  @Prop isOuterHomeAod: boolean = false;
  @State contextResponseRegion: Array<Rectangle> | Rectangle = {
    x: 0,
    y: 0,
    width: '100%',
    height: '100%'
  }
  @State iconResponseRegion: Array<Rectangle> | Rectangle = {
    x: 0,
    y: 0,
    width: '100%',
    height: '100%'
  }

  private liveViewData: LiveViewData = new LiveViewData();
  private touchEvent: (event?: TouchEvent) => void = () => {};
  mainMarqueeContent: CapsuleMarqueeContent = new CapsuleMarqueeContent();
  extentMarqueeContent: CapsuleMarqueeContent = new CapsuleMarqueeContent();
  private listener: inspector.ComponentObserver =
    inspector.createComponentObserver(LiveViewCommonConstants.CAPSULE_SCREEN_RECORD_TIMER_CONTENT);
  private onDrawComplete = () => { // 组件绘制完成回调
    const componentRect: componentUtils.ComponentInfo =
      componentUtils.getRectangleById(LiveViewCommonConstants.CAPSULE_SCREEN_RECORD_TIMER_CONTENT);
    if (componentRect.size.width > 0 && componentRect.size.height > 0) {
      this.checkResponseRegion(componentRect)
    } else {
      log.error('getRectangleById TimerContent error')
    }
  };

  private buttonAccessibilityText: string = '';

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.getButtonAccessibilityText();
    // 监听组件绘制
    this.listener.on('draw', this.onDrawComplete);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear is normal list display:' + this.marqueeEnabled?.toString());
    this.listener.off('draw', this.onDrawComplete);
  }

  build() {
    Row() {
      Row() {
        CapsuleMarquee({
          content: this.getMainMarqueeContent(),
          marqueeEnabled: this.marqueeEnabled,
          isAnimation: this.isAnimation
        })
          .accessibilityText(this.shouldHideContent ? ResUtils.getInnerString($r('app.string.please_unlock')) :
          LiveAccessibilityUtil.getTImeAccessibilityText(this.timeData))
      }
      .id(LiveViewCommonConstants.CAPSULE_SCREEN_RECORD_TIMER_CONTENT)
      .height('100%')
      .opacity(this.textOpacity)
      .margin({
        left: this.capsuleListState.capsuleTextMargin,
        right: this.capsuleListState.capsuleTextMargin
      })
      .responseRegion(this.contextResponseRegion)
      .onTouch(this.touchEvent)

      CapsuleIcon({
        isScreenRecord: true,
        data: this.capsuleData,
        iconOpacity: this.iconOpacity,
      })
        .accessibilityText(this.buttonAccessibilityText)
        .responseRegion(this.iconResponseRegion)
        .onClick(this.clickEvent)
    }
    .draggable(false)
    .width('100%')
    .height('100%')
  }

  private getMainMarqueeContent(): CapsuleMarqueeContent {
    this.mainMarqueeContent.contentText =
      this.shouldHideContent ? ResUtils.getInnerString($r('app.string.please_unlock')) : this.getMainText();
    this.mainMarqueeContent.contentWidth = this.capsuleListState.capsuleMainTextWidth;
    this.mainMarqueeContent.textSize = this.capsuleListState.getCapsuleTextSize(this.capsuleData);
    this.mainMarqueeContent.textColor = this.fontColor;
    return this.mainMarqueeContent;
  }

  private getMainText(): string | undefined {
    // 只有扩展形态小外屏锁屏需要展示胶囊并且锁屏时需要隐藏胶囊内容
    if (this.isOuterHomeAod) {
      return ResUtils.getInnerString(this.timeData?.isCountDown ?
        $r('app.string.aod_count_down_capsule_timer_text') :
        $r('app.string.aod_timing_capsule_timer_text'));
    }
    let mainText = this.capsuleListState.getTimeCapsuleMainText(this.timeData);
    if (this.capsuleListState.isSplicing) {
      return `${mainText}  ${this.getExtendText()}`;
    }
    return mainText;
  }

  private getExtendText(): string | undefined {
    return this.capsuleData?.extend ?? '';
  }

  /**
   * 录屏胶囊停止事件响应
   */
  clickEvent = (_: ClickEvent): void => {
    log.showInfo('ScreenRecord CapsuleClickButton is clicked');
    // 打点事件
    let bundleNameStr : string = this.liveViewData.creatorBundleName;
    let notificationId : number = this.liveViewData.id;
    LiveViewSysEventUtil.reportLiveViewEvent(LiveViewSysEventUtil.NOTIFICATION_CLICK_BUTTON, {
      SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
      CREATOR_BUNDLE_NAME: bundleNameStr,
      NOTIFICATION_ID: String(notificationId)
    });
    // 实况列表展开，不执行录屏停止事件
    if (bannerMgr.getBannerState().bannerPanelType.bannerPanelType === BannerPanelType.TYPE_LIVE_LIST) {
      log.showInfo('bannerPanelType is TYPE_LIVE_LIST.');
      return;
    }
    const buttonData = this.liveViewData?.getButtonData()
    if (buttonData?.length) {
      buttonData[buttonData?.length - 1].clickAction?.(buttonData[buttonData?.length - 1], this.liveViewData)
    } else {
      log.showError('liveViewData is no buttonData');
    }
  }

  private getButtonAccessibilityText(): void {
    const buttonData = this.liveViewData?.getButtonData();
    if (buttonData?.length) {
      this.buttonAccessibilityText = buttonData[buttonData?.length - 1].accessibilityText;
    } else {
      log.showError('liveViewData is no buttonData');
    }
  }

  /**
   * 校验并刷新录屏文字和停止图标热区范围
   */
  private checkResponseRegion(componentRect: componentUtils.ComponentInfo) {
    const contextWidth = px2vp(componentRect.size.width);
    const contextHeight = px2vp(componentRect.size.height);

    const iconRegionWidth =
      LiveViewCapsuleStyle.CAPSULE_BORDER_WIDTH + ResUtils.getNumber($r('app.float.capsule_margin_right')) -
      this.capsuleListState.capsuleTextMargin - contextWidth // 停止按钮的热区宽度须大于icon自身宽度
    const iconRegionHeight = contextHeight; // 停止按钮的热区高度等于胶囊高度，须大于icon自身高度
    const iconRegionOffsetY = (contextHeight - LiveViewCapsuleStyle.CAPSULE_IMAGE_HEIGHT) / 2 // 停止按钮的热区y坐标向上偏移量须大于0

    log.showInfo(`checkResponseRegion iconRegionWidth: ${iconRegionWidth}, iconRegionHeight: ${iconRegionHeight}, iconRegionOffsetY: ${iconRegionOffsetY}, capsuleTextMargin: ${this.capsuleListState.capsuleTextMargin}`);

    if (iconRegionWidth > (LiveViewCapsuleStyle.CAPSULE_IMAGE_WIDTH) &&
      iconRegionHeight > LiveViewCapsuleStyle.CAPSULE_IMAGE_HEIGHT && iconRegionOffsetY > 0) {
      this.iconResponseRegion = {
        x: 0 - this.capsuleListState.capsuleTextMargin,
        y: 0 - iconRegionOffsetY,
        width: iconRegionWidth,
        height: contextHeight
      }
      this.contextResponseRegion = {
        x: 0 - this.capsuleListState.capsuleTextMargin,
        y: 0,
        width: contextWidth + this.capsuleListState.capsuleTextMargin,
        height: '100%'
      }
    } else {
      log.error('checkResponseRegion error')
    }
  }
}