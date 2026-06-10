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

import { StatusBarTint } from '../../common/StatusBarTint';
import { GroupStyle } from '../style/PcStatusBarGroupStyle';
import { PluginProperty } from '../viewdata/PluginProperty';
import { StateManager, StateProperty } from '../manager/StateManager';
// import superPrivacyManager from '@hms.security.superPrivacyManager';
import { LengthMetricsUtil } from '../common/LengthMetricsUtil';
import { dragTriggerUtil } from '@ohos/launchercommon/src/main/ets/utils/DragTriggerUtil';
import { PcStatusBarDragMgr } from '../manager/PcStatusBarDragMgr';
import curves from '@ohos.curves';
import image from '@ohos.multimedia.image';
import { PluginStyle } from '../style/PluginStyle';
import { StyleManager } from '../style/PluginStyleManager';
import { StyleType } from '../utils/enum';
import { DeviceHelper, GlobalContext,
  PluginClickInfo,
  PluginClickType,
  PluginInfo, PluginSlot } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { DragControllerParams } from '@ohos/componenthelper/Index';
import { dragSnapshotHelper, RTLUtil, SnapshotType } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DragEventCallback } from '@ohos/componentdrag/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { StatusBarEventId, StatusBarEventManager } from '../manager/StatusBarEventManager';
import { PluginDragEvent } from '../utils/events';
import { util } from '@kit.ArkTS';
import { PluginStyleUtil } from '../common/PluginStyleUtil';
import { windowMgr } from '@ohos/windowscene';
import { PluginGroupType } from '../common/PluginConstants';

const TAG = 'PcCapsuleComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 图标右间距，定制化处理
 */
const ICON_CONTAINTER_MARGIN_MAP: Map<string | undefined, Resource | null> = new Map([
  [PluginSlot.SLOT_STATUS_SMART_SCREENSHOT, $r('app.float.had_capsule_screenshot_margin')],
  [PluginSlot.SLOT_STATUS_QUICK_NOTE, $r('app.float.had_capsule_quick_note_margin')],
  [PluginSlot.SLOT_STATUS_CAPSULE_SCREENSHOT, $r('app.float.had_capsule_normal_screenshot_margin')],
  [undefined, null]
]);

const DISABLE_DRAG_PLUGIN: Set<string> = new Set([
  PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE,
  PluginSlot.SLOT_STATUS_LOCATION,
  PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT,
  PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD,
  PluginSlot.SLOT_CAPSULE_KEY_MOUSE,
]);

@Component
export struct PcCapsuleComponent {
  @ObjectLink property: PluginProperty;
  isTray: boolean = false;
  /**
   * 容器资源样式
   */
  groupStyle: GroupStyle | null = null;
  pluginInfo: PluginInfo | null = null;
  appId: number = 0;
  @BuilderParam children: () => void;
  /**
   * pc status bar blur container width
   */
  @State containerWidth: number = 0;
  @State stateProperty: StateProperty | null = null;
  // static currentSuperPrivacyMode: superPrivacyManager.SuperPrivacyMode | undefined = undefined;
  static currentSuperPrivacyMode: ESObject | undefined = undefined;

  private snapshotId: string = '';
  private mPcStatusBarDragMgr: PcStatusBarDragMgr = PcStatusBarDragMgr.getInstance();
  private mDragEventCallback: DragEventCallback = {};
  private itemRect: Rectangle = {
    x: 0,
    y: 0,
    width: 0,
    height: 0
  };
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;

  @State isShowDropFrame: boolean = false;
  /**
   * 当前图标可见性
   */
  @State itemVisibility: Visibility = Visibility.Visible;
  // 挤位偏移量
  @State translateX: number = 0;
  @State translateY: number = 0;
  @State iconImage: image.PixelMap | undefined = undefined;
  @State pluginStyle: PluginStyle | null = null;
  private showDropFrameCurve: curves.ICurve = curves.interpolatingSpring(0, 1, 660, 66);
  private translateCurve: curves.ICurve = curves.interpolatingSpring(0.5, 1, 228, 30);

  aboutToAppear(): void {
    // 除企业空间切换图标外，默认隐藏
    this.stateProperty = StateManager.getInstance().getState(this.property.getSlot());
    this.pluginStyle = StyleManager.getInstance()
      .requestStyle(StyleType.PLUGIN, this.property.getSlot()) as PluginStyle;
    if (this.property?.isLocalPlugin()) {
      this.snapshotId = `LocalPluginComponent_${this.property?.getSlot()}`;
    } else if (this.property?.isPluginTypeAccess()) {
      this.snapshotId = `PluginRootComponent_AccessPluginComponent_${this.property?.getSlot()}`;
    } else {
      this.snapshotId = `RemotePluginComponent_PluginComponent_${this.property?.getSlot()}`;
    }
    this.initDragEventCallback();
    this.mPcStatusBarDragMgr.registerDragEvent(this.mDragEventCallback,
      this.property.getSlot() ?? '');
    log.showInfo(`isDragCompleted: ${PcStatusBarDragMgr.isDragCompleted}`);
    log.showInfo(`aboutToAppear ${this.property.getSlot()} ${this.property.isVisible()} group:${this.property.getPluginInGroup()}, hash: ${util.getHash(this)}`);
  }

  aboutToDisappear(): void {
    this.mPcStatusBarDragMgr.unRegisterDragEvent(this.mDragEventCallback,
      this.property.getSlot() ?? '');
    log.showInfo(`aboutToDisappear ${this.property.getSlot()} ${this.property.isVisible()} hash: ${util.getHash(this)}`);
  }

  private onStartSqueezedEvent(translatePosition: number[][]): void {
    if (this.isTray) {
      if (!translatePosition) {
        log.showError('onEventhubItemMoveEvent params error');
        return;
      }
      let endX: number = translatePosition[1][0] - translatePosition[0][0];
      let endY: number = translatePosition[1][1] - translatePosition[0][1];
      log.showInfo('onStartSqueezedEvent, slot:%{public}s, endX:%{public}d, endY:%{public}d',
        this.property.getSlot(), endX, endY);
      this.itemSqueezedAnimate(endX, endY);
      return;
    }
    // 显示落位框
    log.showInfo(`onStartSqueezedEvent ${this.property.getSlot()},` +
      `${this.mPcStatusBarDragMgr.isDragStartDropFrameShow}`);

    if (this.mPcStatusBarDragMgr.isDragStartDropFrameShow) {
      this.isShowDropFrame = true;
    } else {
      animateTo({
        curve: this.showDropFrameCurve,
        onFinish: () => {
        }
      }, () => {
        this.isShowDropFrame = true;
      })
    }
  }

  private itemSqueezedAnimate(endX: number, endY: number, isCancel: boolean = false): void {
    animateTo({
      duration: 200,
      curve: this.translateCurve
    }, () => {
      // 基于当前位置做动画
      const translateXTmp = RTLUtil.isRTL() ? this.translateX - endX : this.translateX + endX;
      const translateYTmp = RTLUtil.isRTL() ? this.translateY - endY : this.translateY + endY;
      this.translateX = isCancel ? endX : translateXTmp;
      this.translateY = isCancel ? endY : translateYTmp;
      log.showInfo('itemSqueezedAnimate, slot:%{public}s, translateX:%{public}d, translateY:%{public}d',
        this.property.getSlot(), this.translateX, this.translateY);
    });
  }

  private onCancelSqueezedEvent(hasAnimation: boolean): void {
    log.showInfo(`onCancelSqueezedEvent ${this.property.getSlot()},` +
      ` hasAnimation: ${hasAnimation}`);
    if (this.isTray) {
      if (hasAnimation) {
        this.itemSqueezedAnimate(0, 0, true);
      } else {
        this.translateX = 0;
        this.translateY = 0;
      }
      return;
    }
    if (hasAnimation) {
      animateTo({
        curve: this.showDropFrameCurve
      }, () => {
        this.isShowDropFrame = false;
      })
    } else {
      this.isShowDropFrame = false;
    }
  }

  private initDragEventCallback(): void {
    this.mDragEventCallback = {
      onItemDragStartEvent: (): void => {
        log.showInfo(`onItemDragStartEvent ${this.property.getSlot()}`);
        StatusBarEventManager.getInstance().postSpecial(
          StatusBarEventId.PLUGIN_DRAG_EVENT,
          new PluginDragEvent(this.property.isPluginTypeAccess(), this.property.getSlot())
        )
        this.itemVisibility = Visibility.None;
      },
      onItemDropStartEvent: (): void => {
      },
      onItemDropEndEvent: (): void => {
        // 显示起拖图标
        log.showInfo(`onItemDropEndEvent ${this.property.getSlot()}`);
        this.itemVisibility = Visibility.Visible;

        if (this.isTray) {
          this.translateX = 0;
          this.translateY = 0;
          return;
        }
      },
      onStartSqueezedEvent: (translatePosition: number[][]): void => {
        if (!PcStatusBarDragMgr.getInstance().getDragItemIsTray()) {
          this.iconImage = PcStatusBarDragMgr.getInstance().getSnapshot();
        }
        if (!PcStatusBarDragMgr.getInstance().getShowDropFrameIcon()) {
          this.iconImage = undefined;
        }
        this.onStartSqueezedEvent(translatePosition);
      },
      onCancelSqueezedEvent: (hasAnimation: boolean): void => {
        if (!PcStatusBarDragMgr.getInstance().getShowDropFrameIcon()) {
          this.iconImage = undefined;
        }
        this.onCancelSqueezedEvent(hasAnimation);
      }
    }
  }

  private triggerDrag(event: TouchEvent): void {
    if (DISABLE_DRAG_PLUGIN.has(this.property.getSlot())) {
      return;
    }
    if (!event || !event?.touches || event?.touches?.length === 0) {
      log.showWarn('triggerDrag event invalid');
      return;
    }
    if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      dragTriggerUtil.preDragTrigger(event);
    }
    log.showInfo(`triggerDrag event.type: ${event.type}` +
      ` pluginSlot: ${this.property.getSlot()}` + ' itemRect : ' + JSON.stringify(this.itemRect) +
      ' triggerDrag windowX : ' + event.touches[0].windowX + ' triggerDrag windowY : ' + event.touches[0].windowY);
    const x = event.touches[0].windowX - ResUtils.getNumberFromLength(this.itemRect?.x);
    const y = event.touches[0].windowY - ResUtils.getNumberFromLength(this.itemRect?.y);
    if (x < 0 || y < 0 || x > ResUtils.getNumberFromLength(this.itemRect?.width) ||
      y > ResUtils.getNumberFromLength(this.itemRect?.height)) {
      return;
    }
    if (event.type === TouchType.Down) {
      this.initDragParams(event);
    }
    if (this.mPcStatusBarDragMgr.snapshotKey.length === 0) {
      log.showError('snapshotKey is empty');
      return;
    }
    dragTriggerUtil.preDragTrigger(event);
  }

  private initDragParams(event: TouchEvent): void {
    log.showInfo(`initDragParams ${this.snapshotId}`);
    // 截图
    this.mPcStatusBarDragMgr.snapshotId = this.snapshotId;
    this.mPcStatusBarDragMgr.snapshotKey = this.snapshotId + '_dockKey';
    dragSnapshotHelper.snapshotFromId(this.mPcStatusBarDragMgr.snapshotId, SnapshotType.BOTH,
      this.mPcStatusBarDragMgr.snapshotKey);

    let pluginStyle = StyleManager.getInstance()
      .requestStyle(StyleType.PLUGIN, this.property.getSlot()) as PluginStyle;
    let touchPointX = (event.touches[0].windowX - ResUtils.getNumberFromLength(this.itemRect?.x)) *
      (ResUtils.getNumberFromLength(pluginStyle.iconWidth) / ResUtils.getNumberFromLength(this.itemRect?.width))
    let touchPointY = (event.touches[0].windowY - ResUtils.getNumberFromLength(this.itemRect?.y)) *
      (ResUtils.getNumberFromLength(pluginStyle.iconHeight) / ResUtils.getNumberFromLength(this.itemRect?.height));
    log.showInfo('initDragParams iconWidth: ' + ResUtils.getNumberFromLength(pluginStyle.iconWidth) +
      ', iconHeight: ' + ResUtils.getNumberFromLength(pluginStyle.iconHeight) +
      ', itemRect width: ' + ResUtils.getNumberFromLength(this.itemRect?.width) +
      ', itemRect Height: ' + ResUtils.getNumberFromLength(this.itemRect?.height) +
      ', event.touches[0].windowX: ' + event.touches[0].windowX +
      ', event.touches[0].windowY: ' + event.touches[0].windowY +
      ', itemRect?.x: ' + this.itemRect?.x +
      ', itemRect?.y: ' + this.itemRect?.y +
      ', touchPointX: ' + touchPointX +
      ', touchPointY: ' + touchPointY);

    // 设置拖拽参数
    let dragControllerParams: DragControllerParams = {
      key: [this.mPcStatusBarDragMgr.snapshotKey],
      dragItemInfo: [{
        extraInfo: this.property.getSlot()
      }],
      dragInfo: {
        pointerId: 0,
        touchPoint: {
          x: touchPointX,
          y: touchPointY
        }
      },
      dragStartCallback: ((event: DragEvent) => {
        log.showInfo(`dragStartCallback`);
        this.mPcStatusBarDragMgr.onDragStart(this.pluginInfo ?? undefined, this.isTray);
      }),
      dragEndCallback: ((event: DragEvent) => {
        log.showInfo(`dragEndCallback`);
        this.mPcStatusBarDragMgr.onDragEnd();
      })
    };
    dragTriggerUtil.initDragParams(dragControllerParams);
  }

  @Builder
  dropFrameBuilder() {
    Column() {
      if (this.iconImage) {
        Image(this.iconImage)
          .draggable(false)
          .width($r('app.float.status_capsule_icon_height'))
          .height($r('app.float.status_capsule_icon_container_height'))
          .enabled(false)
          .opacity(0.5)
      }
    }
    .justifyContent(FlexAlign.Center)
    .onAreaChange((oldValue: Area, newValue: Area) => {
      let rect: Rectangle = {
        x: newValue.globalPosition.x,
        y: newValue.globalPosition.y,
        width: newValue.width,
        height: newValue.height
      };
      this.mPcStatusBarDragMgr.setDropFrameRect(rect, this.pluginInfo?.pluginParseInfo.bundleName ?? '');
    })
    .width($r('app.float.pc_capsule_drop_frame_width'))
    .height($r('app.float.icon_container_size_window'))
  }

  @Builder
  windowStyleBuilder() {
    Row() {
      if (this.isShowDropFrame) {
        this.dropFrameBuilder()
      }
      if (this.property.isVisible()) {
        Row() {
          this.children()
        }
        .height(this.groupStyle?.groupInnerHeight ?? 0)
        // 容器边框圆角
        .borderRadius(this.groupStyle?.groupBgInnerRadius ?? 0)
        .border({
          width: this.groupStyle?.groupBorderWidth,
          color: StatusBarTint.GROUP_INNER_BORDER_COLOR
        })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .id(`PcCapsule_${this.property.getSlot()}`)
        .visibility(this.itemVisibility)
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.itemRect = {
            x: newValue.globalPosition.x,
            y: newValue.globalPosition.y,
            width: newValue.width,
            height: newValue.height
          };
          log.showInfo(`onAreaChange pluginSlot: ${this.property.getSlot()}` + ' itemRect : ' +
          JSON.stringify(this.itemRect));
        })
        if (!this.isTray) {
          Row() {
          }
          .visibility(this.itemVisibility)
          .id(this.property.getSlot() + '_margin')
          .height(this.groupStyle?.groupInnerHeight ?? 0)
          .width(this.property.isVisible() ? $r('app.float.pc_capsule_margin_row_width_visable') :
          $r('app.float.pc_capsule_margin_row_width_unvisable'))
        }
      }
    }
    .justifyContent(FlexAlign.Start)
    .id(`${TAG}_Row_capsule_${this.property?.getSlot()}`)
    .onTouch((event: TouchEvent) => {
      if (this.mPcStatusBarDragMgr.isStatusBarDragging) {
        log.showWarn('The last drag is not complete.');
        setTimeout(() => {
          this.triggerDrag(event);
        }, 800);
      } else {
        this.triggerDrag(event);
      }
      this.handleTouchEventBubble(event);
    })
    .onDragEnter((event: DragEvent, extraParams?: string) => {
      this.mPcStatusBarDragMgr.onDragEnter(this.property.getSlot() ?? '',
        this.isTray, event, extraParams);
    })
    .onDragLeave((event: DragEvent, extraParams?: string) => {
      this.mPcStatusBarDragMgr.onDragLeave(this.property.getSlot() ?? '',
        this.isTray, extraParams);
    })
    .onDrop((event: DragEvent, extraParams?: string) => {
      if (!event) {
        return;
      }
      event.useCustomDropAnimation = true;
      event.setResult(DragResult.DRAG_FAILED);
      this.mPcStatusBarDragMgr.onDrop(this.isTray, event, this.pluginInfo ?? undefined, extraParams);
      event.setResult(DragResult.DRAG_SUCCESSFUL);
    })
    .onDragMove((event: DragEvent, extraParams?: string) => {
      this.mPcStatusBarDragMgr.onDragMove(this.pluginInfo ?? undefined, this.itemRect, event, extraParams);
    })
    .translate({ x: this.translateX, y: this.translateY })
  }

  build() {
    this.windowStyleBuilder()
  }

  private handleTouchEventBubble(event: TouchEvent): void {
    if (event?.type !== TouchType.Down) {
      return;
    }
    const clickInfo: PluginClickInfo | undefined =
      this.property.pluginInfo?.pluginParseInfo['clickInfo'];
    const clickType: string | undefined = clickInfo?.clickType;
    log.showInfo(`slot:${this.property.getSlot()}, clickType:${clickType}`);
    if (clickType === PluginClickType.TYPE_WINDOW) {
      event?.stopPropagation();
    }
  }
}

export default PcCapsuleComponent;