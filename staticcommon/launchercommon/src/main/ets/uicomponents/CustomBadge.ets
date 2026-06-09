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

import curves from '@ohos.curves';
import { AttributeUpdater } from '@ohos.arkui.modifier';
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  Trace,
  StartType,
} from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { GlobalContext, localEventManager } from '@ohos/frameworkwrapper';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import badgeInfo, { BadgeConfigure, BadgeNumberType } from '../configs/BadgeInfo';
import { CommonConstants, DesktopLayoutState, DesktopMode } from '../constants/CommonConstants';
import { EditModeUtils } from '../utils/EditModeUtils';
import { GrayAppListManager } from '../manager/GrayAppListManager';
import { ReceiveEventInfo } from '../bean/ReceiveEventInfo';
import { EventConstants } from '../constants/EventConstants';
import { editModeManager } from '../editmode/model/EditModeManager';
import { LayoutViewModel } from '../TsIndex';
import { StyleConstants } from '../constants/StyleConstants';
import { BaseBundleInfo } from '../bean/BaseBundleInfo';
import { FolderManager } from '../folder/next/common/model/FolderManager';
import { LengthMetrics } from '@kit.ArkUI';

export enum BadgeAnimationType {
  DEFAULT = -1, // 默认值
  MAXIMIZE_DELAY = 0, // 延迟scale放大
  REBOUND_NORMAL = 1, // 回弹
  OPACITY_ZERO = 2, // 渐隐 （增加场景：长按350ms时，角标做150ms的透明度消失动效）
  ZOOM_IN = 3, // 放大至目标大小
  ZOOM_OUT = 4, // 缩小至目标大小
  MAXIMIZE_DELAY_REBOUND = 5, // 延迟scale放大并回弹
  SUPERPOSE_BADGE_REFRESH = 6, // 堆叠总角标数值刷新
  HIDE_WITHOUT_ANIM = 7, // 无动效直接缩放为0
  SMALL_FOLDER_OPEN_REBOUND = 8, // 小文件夹展开态总角标回弹
  SMALL_FOLDER_CLOSE_REBOUND = 9, // 小文件夹收起态总角标回弹
  SMALL_TO_BIG = 10, // 小文件夹切换大文件夹，应用角标延迟scale放大并回弹
  BIG_TO_SMALL = 11, // 大文件夹切换小文件夹，小文件夹总角标延迟scale放大并回弹
  OPEN_FOLDER_REBOUND = 12, //打开文件夹后内部的图标角标动效
  DRAG_DROP = 13, // 图标、小文件夹落位时，角标回弹
  TOUCH_UP = 14, // touch up时恢复角标透明度
  OPEN_FOLDER_BUBBLE_SHOW = 15,
  OPEN_FOLDER_COMPONENT_HIDE = 16,
  CLOSE_FOLDER_BUBBLE_HIDE = 17,
  CLOSE_FOLDER_COMPONENT_SHOW = 18,
}

const TAG = 'CustomBadge';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);
const MAX_SCALE_FACTOR: ScaleOptions = {x: 1.2, y: 1.2};
const NORMAL_SCALE_FACTOR: ScaleOptions = {x: 1, y: 1};
const MIN_SCALE_FACTOR: ScaleOptions = {x: 0, y: 0};
const SUPERPOSE_APP_ICON_Y_OFFSET_MULTIPLE_4 = 4;

export class CustomBadgeModifier extends AttributeUpdater<CommonAttribute> {
  public width: number = 0;
  public height: number = 0;
  public xOffset: number = 0;
  public yOffset: number = 0;
  public onInit?: () => void;

  initializeModifier(instance: CommonAttribute): void {
    this.onInit?.();
  }

  public updateParameter(textWidth: number, textHeight: number, xOffset: number, yOffset: number): void {
    this.width = textWidth;
    this.height = textHeight;
    this.xOffset = xOffset;
    this.yOffset = yOffset;
  }
}

@Component
export struct CustomBadge {
  @Prop ratio: number = 1;
  @Prop @Watch('onBadgeNumberChange') badgeNumber: number = 0;
  iconId: string = '';
  alignOption: AlignRuleOption | null = null;
  modifier: CustomBadgeModifier = new CustomBadgeModifier();
  iconSize: number = 0;
  @Prop bindFolderId: string = '';
  @State badgeParameter: BadgeConfigure = new BadgeConfigure();
  isSuperposeApp: boolean = false;
  private isUpdateSuperposeBadge: boolean = true;
  private itemOffset?: Position;
  private xOffset: number = 0;
  private yOffset: number = 0;
  private badgeValue: string = '';
  @Prop badgeOpacity: number = CommonConstants.OPACITY_ONE;
  @Prop badgeScale: ScaleOptions = {x: 1, y: 1};
  @Prop badgeVisible: boolean = true;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageLink('isExpandFolderAnimClosing') isExpandFolderAnimClosing: boolean = false;
  @Prop @Watch('callBadgeAnimate') badgeAnimate: BadgeAnimationType = BadgeAnimationType.DEFAULT;
  @Prop @Watch('setBadgeSize') isBadgeMinimize: boolean = false;
  @State isShowBadge: boolean = editModeManager.isInNormalMode(); // 用于编辑模式控制角标隐藏
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private keyName: string = '';
  @Prop isIgnoreDesktopModeChange: boolean = false;
  private isBadgeSmaller: boolean = false;
  private bundleName: string = '';
  private onDesktopModeChangeEvent: Function = (): void => this.onDesktopModeChange();
  private isFolderDisappear: boolean = false;
  private startType: StartType = StartType.APP;
  private appIndex: number = 0;

  @State isClosing: boolean = false;
  private onChangeIsClosing: Function = (data: boolean): void => this.changeIsClose(data);

  private initEventhubEvent(): void {
    if (CheckEmptyUtils.checkStrIsEmpty(this.keyName)) {
      log.showError('Failed to bind the custom badge appIcon launch state, keyName is invalid.');
      return;
    }

    // 订阅编辑模式切换事件
    this.desktopContext?.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext?.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
  }

  private getBadgeReaderText(): string {
    if (this.isAccessibilityMode && this.badgeNumber > 0) {
      return this.desktopContext?.resourceManager
        .getPluralStringValueSync($r('app.plural.number_of_notifications').id, this.badgeNumber) || '';
    }
    return '';
  }

  /**
   * 应用启动退出，角标处理函数
   * @param isStartup true: 应用启动 false: 应用退出
   */
  private onBadgeScaledEvent(isStartup: boolean): void {
    if (this.badgeVisible) {
      log.showWarn('app badge is visible, not need deal animate event');
      return;
    }
    let itemInfo: BaseBundleInfo = {
      bundleName: this.bundleName,
      appIndex: this.appIndex,
    };
    if (this.startType === StartType.RECENT_DOCK_APP || GrayAppListManager.getInstance().isGrayAppIcon(itemInfo)) {
      log.showWarn('app is gray icon and dock recent icon, not need deal. ' +
        'bundleName = %{public}s, startType = %{public}s, badgeVisible = %{public}s',
        this.bundleName, this.startType, this.badgeVisible);
      return;
    }
    this.desktopContext?.eventHub.on(EventConstants.EVENT_FOLDER_CLOSING, this.onChangeIsClosing);
    log.showWarn('App launch state change, isStartup=%{public}s, the app is %{public}s, isClosing is %{public}s',
      isStartup, this.keyName, this.isClosing);
    if (!isStartup && !this.isClosing) {
      this.badgeScale = MIN_SCALE_FACTOR;
      this.badgeMaximize(0, true);
    }
    this.isClosing = false;
  }

  private changeIsClose(flag: boolean):void {
    this.isClosing = flag;
  }

  private registerEvent(): void {
    let hiddenBageEvent: string = `hiddenBadge${this.keyName}`;
    // 注册应用启动退出事件
    let launchAppEvent: string = `${CommonConstants.EVENTHUB_APP_LAUNCH_STATE}${this.keyName}`;
    localEventManager.registerEventListener(this.mLocalEventListener, [hiddenBageEvent, launchAppEvent]);
  }

  private readonly mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params?: boolean) => {
      let eventIdLaunchApp: string = `${CommonConstants.EVENTHUB_APP_LAUNCH_STATE}${this.keyName}`;
      if (event === `hiddenBadge${this.keyName}`) {
        if (params) {
          this.badgeScale = MIN_SCALE_FACTOR;
        } else {
          this.badgeScale = NORMAL_SCALE_FACTOR;
        }
      } else if (event === eventIdLaunchApp) {
        this.onBadgeScaledEvent(params as boolean);
        log.showWarn(`Init badge eventhub for app ${this.keyName}`);
      }
    }
  }

  private callBadgeAnimate(): void {
    log.showWarn('callBadgeAnimate badgeAnimate=%{public}d, item is %{public}s', this.badgeAnimate, this.keyName);
    switch (this.badgeAnimate) {
      case BadgeAnimationType.MAXIMIZE_DELAY:
        this.badgeMaximize(250, false);
        break;
      case BadgeAnimationType.REBOUND_NORMAL:
        this.badgeRebound();
        break;
      case BadgeAnimationType.OPACITY_ZERO:
        this.badgeTransparent();
        break;
      case BadgeAnimationType.ZOOM_IN:
        this.badgeResize(false);
        break;
      case BadgeAnimationType.ZOOM_OUT:
        this.badgeResize(true);
        break;
      case BadgeAnimationType.MAXIMIZE_DELAY_REBOUND:
        this.badgeMaximize(250, true);
        break;
      case BadgeAnimationType.SUPERPOSE_BADGE_REFRESH:
        this.updateBadgeParameter(true);
        break;
      case BadgeAnimationType.HIDE_WITHOUT_ANIM:
        this.badgeHideWithoutAnim();
        break;
      case BadgeAnimationType.SMALL_FOLDER_OPEN_REBOUND:
        this.badgeMaximize(400, true);
        break;
      case BadgeAnimationType.SMALL_FOLDER_CLOSE_REBOUND:
        this.badgeReboundWithCloseSmallFolder(400);
        break;
      case BadgeAnimationType.SMALL_TO_BIG:
        this.badgeVisible = true;
        this.startBadgeDisplayAnimate(550, true);
        break;
      case BadgeAnimationType.BIG_TO_SMALL:
      case BadgeAnimationType.OPEN_FOLDER_REBOUND:
        this.startBadgeDisplayAnimate(250, true);
        break;
      case BadgeAnimationType.DRAG_DROP:
        if (this.isShowBadge) {
          this.startBadgeDisplayAnimate(0, true);
        }
        break;
      case BadgeAnimationType.TOUCH_UP:
        this.resetBadgeParam();
        break;
      case BadgeAnimationType.OPEN_FOLDER_BUBBLE_SHOW:
        this.folderItemShowBadgeSharp();
        break;
      case BadgeAnimationType.OPEN_FOLDER_COMPONENT_HIDE:
        this.folderItemHideBadgeTransparent();
        break;
      case BadgeAnimationType.CLOSE_FOLDER_BUBBLE_HIDE:
        this.folderItemHideBadgeTransparent();
        break;
      case BadgeAnimationType.CLOSE_FOLDER_COMPONENT_SHOW:
        this.folderItemShowBadgeSharp(0);
        break;
      default:
        log.showWarn(`The animation type is invalid: ${this.badgeAnimate}`);
    }
  }

  private resetBadgeParam(): void {
    this.badgeOpacity = CommonConstants.OPACITY_ONE;
    this.badgeScale = NORMAL_SCALE_FACTOR;
  }

  private startBadgeDisplayAnimate(delay: number, isNeedRebound: boolean) {
    this.badgeHideWithoutAnim();
    this.badgeMaximize(delay, isNeedRebound);
  }

  private setBadgeSize(): void {
    log.showDebug(`The custom badge change size: ${this.isBadgeMinimize}`);
    this.updateBadgeParameter(this.isBadgeMinimize);
  }

  private badgeMaximize(delay: number, isNeedRebound: boolean): void {
    this.startBadgeMaximizeAnimate(delay, isNeedRebound, () => {
      this.badgeScale = MAX_SCALE_FACTOR;
    });
  }

  private startBadgeMaximizeAnimate(delay: number, isNeedRebound: boolean, eventFunc: () => void): void {
    this.badgeOpacity = CommonConstants.OPACITY_ONE;
    Trace.start('startBadgeMaximizeAnimate');
    animateTo({
      duration: 200,
      curve: curves.cubicBezierCurve(0.2, 0, 0.6, 1),
      delay: delay,
      onFinish: () => {
        if (isNeedRebound) {
          this.badgeRebound();
        }
        Trace.end('startBadgeMaximizeAnimate');
      }
    }, eventFunc);
  }

  private badgeReboundWithCloseSmallFolder(delay: number): void {
    Trace.start('badgeReboundWithCloseSmallFolder');
    animateTo({
      duration: 200,
      delay: delay,
      curve: curves.cubicBezierCurve(0.2, 0, 0.6, 1),
      onFinish: () => {
        Trace.end('badgeReboundWithCloseSmallFolder');
        this.badgeScale = MAX_SCALE_FACTOR;
        animateTo({
          duration: 200,
          curve: curves.cubicBezierCurve(0.3, 0, 0.4, 1),
        }, () => {
          this.badgeOpacity = CommonConstants.OPACITY_ONE;
          this.badgeScale = NORMAL_SCALE_FACTOR;
        });
      }
    }, () => {
      this.badgeOpacity = CommonConstants.OPACITY_ZERO;
    });
  }

  private badgeRebound(): void {
    this.badgeScale = MAX_SCALE_FACTOR;
    Trace.start('badgeRebound');
    animateTo({
      duration: 200,
      curve: curves.cubicBezierCurve(0.3, 0, 0.4, 1),
      onFinish: () => {
        Trace.end('badgeRebound');
      }
    }, () => {
      this.badgeScale = NORMAL_SCALE_FACTOR;
    });
  }

  private badgeHideWithoutAnim(): void {
    this.badgeScale = MIN_SCALE_FACTOR;
  }

  private folderItemHideBadgeTransparent(): void {
    this.badgeOpacity = CommonConstants.OPACITY_ZERO;
    this.badgeScale = MIN_SCALE_FACTOR;
  }

  private folderItemShowBadgeSharp(delay?: number): void {
    this.badgeOpacity = CommonConstants.OPACITY_ZERO;
    this.badgeScale = MIN_SCALE_FACTOR;
    /*
     * 和UX沟通，希望最好的文件夹打开关闭角标动效是随图标整体缩放；其次是接受立刻消失、然后图标稳定后出现。
     * 当前功耗和工作量的原因，调整动效在图标稳定后出现。当前仅是临时方案，在控制调整到VM的打开完成后时机，切换为ZOOM_IN
     */
    this.startBadgeTransparentAnimate(delay ?? 300, 150,
      () => {
        this.badgeOpacity = CommonConstants.OPACITY_ONE;
        this.badgeScale = NORMAL_SCALE_FACTOR;
      },
      () => { }
    );
  }

  private badgeTransparent(): void {
    this.badgeOpacity = CommonConstants.OPACITY_ONE;
    this.startBadgeTransparentAnimate(0, 150,
      () => { this.badgeOpacity = CommonConstants.OPACITY_ZERO; },
      () => {}
    );
  }

  private startBadgeTransparentAnimate(delay: number, duration: number, eventFunc: () => void,
    finishFunc: () => void): void {
    Trace.start('startBadgeTransparentAnimate');
    animateTo({
      delay: delay,
      duration: duration,
      curve: Curve.Sharp,
      onFinish: () => {
        finishFunc()
        Trace.end('startBadgeTransparentAnimate');
      }
    }, eventFunc)
  }

  private badgeResize(isZoomOut: boolean): void {
    Trace.start('badgeResize');
    animateTo({
      duration: 450,
      curve: curves.cubicBezierCurve(0.2, 0, 0, 1),
      onFinish: () => {
        Trace.end('badgeResize');
      }
    }, () => {
      this.updateBadgeParameter(isZoomOut);
    })
  }

  aboutToAppear(): void {
    log.showWarn(`customBadge aboutToAppear, bundleName: ${this.bundleName}, badgeNumber: ${this.badgeNumber}`);
    this.updateBadgeParameter(this.isBadgeSmaller);
    this.registerEvent();
    this.initEventhubEvent();
    this.modifier.onInit?.();
  }

  aboutToDisappear(): void {
    log.showWarn(`customBadge aboutToDisappear, bundleName: ${this.bundleName}`);
    localEventManager.unregisterEventListener(this.mLocalEventListener);
    // 取消订阅
    this.desktopContext?.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext?.eventHub.off(EventConstants.EVENT_FOLDER_CLOSING, this.onChangeIsClosing);
  }

  private onBadgeNumberChange(): void {
    log.showWarn(`onBadgeNumberChange, bundleName: ${this.bundleName}, badgeNumber: ${this.badgeNumber}`);
    this.updateBadgeParameter(this.isBadgeSmaller);
  }

  private updateBadgeParameter(isBadgeSmaller: boolean): void {
    this.isBadgeSmaller = isBadgeSmaller;
    if (!this.isUpdateSuperposeBadge) {
      return;
    }
    if (LayoutViewModel.getInstance().getDesktopModel() === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
      this.badgeParameter = this.getSimpleBadgeParameter();
    } else {
      if (this.badgeNumber > BadgeNumberType.BADGE_NUM_ZERO && this.badgeNumber <= BadgeNumberType.BADGE_NUM_NINE) {
        this.badgeParameter = (isBadgeSmaller || this.isSuperposeApp ? badgeInfo.get('InFolder1to9') :
        badgeInfo.get('From1to9')) as BadgeConfigure;
      } else if (this.badgeNumber > BadgeNumberType.BADGE_NUM_NINE &&
        this.badgeNumber <= BadgeNumberType.BADGE_NUM_NINETY_NINE) {
        this.badgeParameter = (isBadgeSmaller || this.isSuperposeApp ? badgeInfo.get('InFolder10to99') :
        badgeInfo.get(`From10to99`)) as BadgeConfigure;
      } else {
        this.badgeParameter = (isBadgeSmaller || this.isSuperposeApp ? badgeInfo.get('InFolderMoreThan99') :
        badgeInfo.get('MoreThan99')) as BadgeConfigure;
      }
    }
    this.badgeValue = this.badgeNumber > BadgeNumberType.BADGE_NUM_NINETY_NINE ? '99+' : this.badgeNumber?.toString();
    // 图标设置偏移量，角标也同样设置偏移量
    this.xOffset = this.badgeParameter?.badgeDistanceIcon + (this.itemOffset?.x as number ?? 0);
    this.yOffset = (this.isSuperposeApp ? -(this.iconSize / SUPERPOSE_APP_ICON_Y_OFFSET_MULTIPLE_4 +
      this.badgeParameter?.badgeDistanceIcon) : - (this.badgeParameter?.badgeDistanceIcon)) +
      (this.itemOffset?.y as number ?? 0);
    this.modifier.updateParameter(this.badgeParameter.textWidth, this.badgeParameter.textHeight,
      this.xOffset, this.yOffset);
  }

  private getSimpleBadgeParameter(): BadgeConfigure {
    if (this.badgeNumber > BadgeNumberType.BADGE_NUM_ZERO && this.badgeNumber <= BadgeNumberType.BADGE_NUM_NINE) {
      this.badgeParameter = badgeInfo.get('SimpleFrom1to9') as BadgeConfigure;
    } else if (this.badgeNumber > BadgeNumberType.BADGE_NUM_NINE && this.badgeNumber <=
      BadgeNumberType.BADGE_NUM_NINETY_NINE) {
      this.badgeParameter = (badgeInfo.get(`SimpleFrom10to99`)) as BadgeConfigure;
    } else {
      this.badgeParameter = (badgeInfo.get('SimpleMoreThan99')) as BadgeConfigure;
    }
    return this.badgeParameter;
  }

  private onDesktopModeChange(): void {
    if (editModeManager.isInEditMode()) {
      // isShowBadge置false不能放在animateTo闭包中，否则会导致角标消失时向右位移
      animateTo({
        duration: 150,
        curve: Curve.Sharp,
        onFinish: () => {
          if (editModeManager.isInEditMode()) {
            this.isShowBadge = false;
          }
        }
      }, () => {
        this.badgeOpacity = CommonConstants.OPACITY_ZERO;
      })
      return;
    }

    // 文件夹展开态退出编辑模式，大文件夹堆叠总角标、小文件夹总角标不走回弹动效
    if (this.isIgnoreDesktopModeChange) {
      this.isShowBadge = true;
      return;
    }

    const resizeId: string = FolderManager.getInstance().getResizeFolderId();
    log.showInfo('exit editMode, resizeId=%{public}s bindFolderId=%{public}s keyName=%{public}s',
      resizeId, this.bindFolderId, this.keyName);

    // 非文件夹相关角标，或者不在改变大小状态的文件夹角标，则直接回弹出现
    if (this.bindFolderId === '' || resizeId !== this.bindFolderId) {
      this.badgeScale = MIN_SCALE_FACTOR;
      this.isShowBadge = true;
      this.startBadgeMaximizeAnimate(250, true, () => {
        this.badgeScale = MAX_SCALE_FACTOR;
      });
      return;
    }

    // 在改变大小状态的文件夹相关角标，则设置Visible，使原先的动效可见
    this.isShowBadge = true;
    return;
  }

  private folderDisappearAnimate(): void {
    if (this.isFolderDisappear) {
      animateTo({
        duration: 400,
        curve: Curve.Friction,
        onFinish: () => {
        }
      }, () => {
        this.updateBadgeParameter(false);
      })
    }
  }

  private getBadgeVisibility(): boolean {
    log.showWarn('badgeVisible: %{public}s, isShowBadge: %{public}s, isExpandFolderAnimClosing: %{public}s,' +
      'isSuperposeApp: %{public}s', this.badgeVisible, this.isShowBadge, this.isExpandFolderAnimClosing,
      this.isSuperposeApp);
    return this.badgeVisible && this.isShowBadge || (this.isExpandFolderAnimClosing && !this.isSuperposeApp);
  }

  build() {
    if (this.badgeNumber > 0) {
      Text(this.badgeValue)
        .fontSize(this.badgeParameter.textFontSize * this.ratio)
        .borderRadius(this.ratio * this.badgeParameter.textHeight / 2)
        .accessibilityText(this.getBadgeReaderText())
        .width(this.badgeParameter.textWidth * this.ratio)
        .height(this.badgeParameter.textHeight * this.ratio)
        .offset({
          start: LengthMetrics.vp(this.xOffset * this.ratio),
          top: LengthMetrics.vp(this.yOffset * this.ratio),
        })
        .opacity(this.badgeOpacity)
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .backgroundColor(Color.Red)
        .visibility(this.getBadgeVisibility() ? Visibility.Visible : Visibility.None)
        .renderFit(RenderFit.CENTER)
        .scale(this.badgeScale)
        .alignRules(this.alignOption)
        .id(`CustomBadge_${this.iconId}`)
        .attributeModifier(this.modifier)
        .maxFontScale((this.badgeParameter.textFontSize === StyleConstants.DEFAULT_12 ?
          StyleConstants.FONT_MAX_SCALE_BADGE_TEXT : StyleConstants.FONT_MAX_SCALE_BADGE_SMALL_TEXT) * this.ratio)
        .onAppear(() => {
          this.folderDisappearAnimate();
        })
    }
  }
}