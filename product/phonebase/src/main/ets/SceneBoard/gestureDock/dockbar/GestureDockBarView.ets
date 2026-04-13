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

import { CheckEmptyUtils } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { ResUtils, SCBScreenProperty } from '@ohos/windowscene';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { LengthMetrics } from '@kit.ArkUI';
import { DockType, GestureDockConstants, GestureDockMode } from '../common/GestureDockConstants';
import { GestureDockBarViewDataMgr } from './viewmodel/viewdata/GestureDockBarViewDataMgr';
import { DockBarOutParam, DockBarParam,
  DockBarScrollerParam } from './viewmodel/viewdata/GestureDockBarParam';
import { GestureDockItemInfo } from './model/GestureDockItemInfo';
import { GestureDockUtil } from '../common/util/GestureDockUtil';
import { GestureDockAppItemView } from '../dockappitem/GestureDockAppItemView';
import { GestureDockViewParam } from '../dock/viewmodel/viewdata/GestureDockParam';
import { GestureDockDirection } from '../dock/viewmodel/viewevent/GestureDockViewEventMgr';
import GestureDockBarViewEventMgr from './viewmodel/viewevent/GestureDockBarViewEventMgr';
import { GestureDockBarViewModel } from './viewmodel/GestureDockBarViewModel';
import { KeyCode } from '@kit.InputKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const BLENDMODE_SRC_OVER: number = 1000;
const BLENDMODE_DESTINATION_IN: number = 6;
const RESIDENT: string = 'resident';
const RECENT: string = 'recent';
const TAG = 'GestureDockBarView';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * GestureDockBarView
 */
@Component
export struct GestureDockBarView {
  private viewDataMgr: GestureDockBarViewDataMgr = new GestureDockBarViewDataMgr();
  private viewEventMgr: GestureDockBarViewEventMgr = new GestureDockBarViewEventMgr(this.viewDataMgr);

  @Link screenProperty: SCBScreenProperty;
  @Link gestureDockParam: GestureDockViewParam;
  @StorageLink('gestureDockList') residentApps: GestureDockItemInfo[] = [];
  @StorageLink('currColorMode') @Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  @State dockBarParam: DockBarParam = this.viewDataMgr.dockBarParam;
  @State leftBarOutParam: DockBarOutParam = this.viewDataMgr.leftBarOutParam;
  @State rightBarOutParam: DockBarOutParam = this.viewDataMgr.rightBarOutParam;
  @State dockBarScrollerParam: DockBarScrollerParam = this.viewDataMgr.dockBarScrollerParam;

  private onColorModeChange(): void {
    this.viewEventMgr?.onColorModeChange(this.currColorMode);
  }

  aboutToAppear(): void {
    GestureDockBarViewModel.getInstance().initViewModel(this.viewEventMgr);
    this.viewEventMgr.aboutToAppear(this.screenProperty);
    this.viewEventMgr.onColorModeChange(this.currColorMode);
  }

  aboutToDisappear(): void {
    this.viewEventMgr.aboutToDisappear();
    GestureDockBarViewModel.getInstance().clearViewModel();
  }

  build() {
    Stack() {
      if (this.dockBarParam.isLeft) {
        this.dockBuilder(GestureDockDirection.GESTURE_DOCK_LEFT);
      } else {
        this.dockBuilder(GestureDockDirection.GESTURE_DOCK_RIGHT);
      }
    }
    .tabIndex(2)
    .width('100%')
    .height(this.viewDataMgr.getGestureDockBarHeight(this.screenProperty))
    .hitTestBehavior(HitTestMode.None)
    .align(Alignment.Start)
    .position({ x: 0, y: ResUtils.getNumber($r('app.float.status_bar_phone_height')) })
    .onKeyPreIme((event: KeyEvent) => {
      log.showInfo(`onKeyPreIme event keyCode:${event.keyCode}`);
      if (event.keyCode === KeyCode.KEYCODE_MOVE_END) {
        return true;
      }
      if (this.gestureDockParam.isShowAllApps && event.keyCode === KeyCode.KEYCODE_MOVE_HOME) {
        try {
          focusControl.requestFocus(GestureDockConstants.ALL_APPS_TITLEBAR_ID);
        } catch (error) {
          log.showError(`GestureDockAllAppsView_titleBarBuilder getFocus error: ${error}`);
        }
      }
      return false;
    })
  }

  @Builder
  dockBuilder(direction: number) {
    Column() {
      Stack() {
        this.ScrollBuilder(direction)
      }
      .linearGradient({
        angle: 0,
        colors: [
          ['rgba(255,255,255,0)', 0], ['rgba(255,255,255,1)', this.dockBarParam.blendRatio], ['rgba(255,255,255,1)',
          1 - this.dockBarParam.blendRatio], ['rgba(255,255,255,0)', 1]
        ]
      })
      .blendMode(BLENDMODE_SRC_OVER)
      .constraintSize({ maxHeight: this.dockBarParam.maxHeight })

      if (this.gestureDockParam.gestureDockShowMode < GestureDockMode.ALL_APPS) {
        Image($r('app.media.gesture_dock_allApps'))
          .editImageStyle()
          .onClick(() => {
            this.viewEventMgr?.onAllAppsIconClick();
          })
      } else if (this.gestureDockParam.gestureDockShowMode === GestureDockMode.ALL_APPS) {
        Image($r('app.media.square_and_pencil'))
          .editImageStyle()
          .matchTextDirection(true)
          .padding(GestureDockConstants.GESTURE_DOCK_EDIT_ICON_PADDING)
          .backgroundColor('rgba(255, 255, 255, 0.2)')
          .onClick(() => {
            this.viewEventMgr?.onDockEditIconClick();
          })
          .id(`${TAG}_square_and_pencil`)
          .onAppear(() => {
            try {
              this.getUIContext().getFocusController().requestFocus(`${TAG}_square_and_pencil`);
            } catch (error) {
              log.showInfo(`_square_and_pencil getFocus error: ${error}`);
            }
          })
      } else {
        Stack() {
          Image($r('app.media.checkmark_square'))
            .checkImageStyle()

          Image($r('app.media.checkmark'))
            .checkImageStyle()
            .padding(GestureDockConstants.GESTURE_DOCK_EDIT_ICON_PADDING)
        }
        .id(`${TAG}_checkmark`)
        .onAppear(() => {
          try {
            this.getUIContext().getFocusController().requestFocus(`${TAG}_checkmark`);
          } catch (error) {
            log.showInfo(`_checkmark getFocus error: ${error}`);
          }
        })
        .editImageStyle()
        .onClick((event?: ClickEvent) => {
          this.viewEventMgr?.onDockEditCheckMarkIconClick();
        })
      }
    }
    .width(GestureDockConstants.GESTURE_DOCK_WIDTH)
    .offset({
      x: this.viewDataMgr.getDockOffsetX(direction, this.screenProperty.width)
    })
    .borderRadius(GestureDockConstants.GESTURE_DOCK_RADIUS)
    .padding({
      start: LengthMetrics.vp(GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / 2),
      end: LengthMetrics.vp(GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / 2)
    })
    .shadow(this.gestureDockParam.isShowAllApps ? undefined :
      (direction === GestureDockDirection.GESTURE_DOCK_LEFT ? this.leftBarOutParam.shadow :
      this.rightBarOutParam.shadow))
    .translate({
      x: this.viewDataMgr.getDockTranslateX(direction)
    })
    .backgroundEffect({
      policy: 1,
      radius: this.dockBarParam.blurRadius,
      saturation: ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_saturation')),
      color: this.dockBarParam.backGroundColor
    }, { disableSystemAdaptation: true })
    .constraintSize({ maxHeight: this.dockBarParam.maxHeight + GestureDockConstants.GESTURE_DOCK_ICON_SIZE +
      GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE })
    .id(TAG + direction)
  }

  @Builder
  ScrollBuilder(direction: number) {
    Scroll(this.viewDataMgr.getScroller(direction === GestureDockDirection.GESTURE_DOCK_LEFT)) {
      Column() {
        if (this.dockBarScrollerParam.isRecentAppShow) {
          this.recentDockBuilder(direction)
        }

        this.residentBuilder(direction)
      }
      .id(`gesture_dock_${direction}`)
    }
    .constraintSize({ maxHeight: this.dockBarParam.maxHeight })
    .blendMode(BLENDMODE_DESTINATION_IN, BlendApplyType.OFFSCREEN)
    .edgeEffect(EdgeEffect.Spring)
    .align(Alignment.Top)
    .scrollBar(BarState.Off)
    .onScroll((xOffset: number, yOffset: number) => {
      this.viewEventMgr?.onGestureDockScroll(direction, yOffset);
    })
    .id(`${GestureDockConstants.GESTURE_DOCK_SCROLL}${direction}`)
  }

  @Builder
  recentDockBuilder(direction: number) {
    List({ space: 0 }) {
      ForEach(this.dockBarScrollerParam.recentApps.slice(0, GestureDockConstants.GESTURE_DOCK_MAX_RECENT),
        (item: GestureDockItemInfo, index: number) => {
          ListItem() {
            this.appItemBuilder(item, direction, DockType.RECENT, index);
          }
        }, (item: GestureDockItemInfo) => {
          let itemKey = `recent_${direction}_${item.bundleName}_${item.appIndex}`;
          const appKey = itemKey + `${item.installTime}_${item.appIconId}`;
          return appKey;
        });
    }
    .focusable(this.gestureDockParam.gestureDockShowMode === GestureDockMode.EDIT ? false : true)
    .margin({ top: GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / 2 })
    .alignListItem(ListItemAlign.Center)

    Divider()
      .vertical(false)
      .id(`gesture_dock_divider_${direction}`)
      .strokeWidth(px2vp(1))
      .color(this.dockBarScrollerParam.dividerColor)
      .margin({
        top: GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / 2,
      })
      .padding({ left: GestureDockConstants.GESTURE_DOCK_DIVIDER_PADDING,
        right: GestureDockConstants.GESTURE_DOCK_DIVIDER_PADDING })
  }

  @Builder
  residentBuilder(direction: number) {
    List({ space: 0 }) {
      ForEach(this.residentApps, (item: GestureDockItemInfo, index: number) => {
        ListItem() {
          this.appItemBuilder(item, direction, DockType.RESIDENT, index);
        }
      }, (item: GestureDockItemInfo, index: number) => {
        return GestureDockUtil.getItemKey(RESIDENT, direction, index, item);
      });
    }
    .margin({
      top: GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / 2,
      bottom: GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / 2
    })
    .listDirection(Axis.Vertical)
    .alignListItem(ListItemAlign.Center)
    .enableScrollInteraction(false)
    .editMode(true)
    .scrollBar(BarState.Off)
  }

  @Builder
  appItemBuilder(item: GestureDockItemInfo, direction: number, dockType: number, index: number) {
    if (dockType === DockType.RECENT || !CheckEmptyUtils.isEmpty(item.bundleName)) {
      GestureDockAppItemView({
        screenProperty: this.screenProperty,
        gestureDockItemInfo: item,
        dockDirection: direction,
        dockType: dockType,
        gestureDockParam: this.gestureDockParam,
        itemOnClick: (event?: ClickEvent) => {
          this.viewEventMgr?.onItemClick(event, item, direction, dockType);
        }
      })
        .id(`${direction}_${dockType}_${item.bundleName}_${item.abilityName}_${item.appIndex}_${index}`)
    } else if (this.gestureDockParam.gestureDockShowMode === GestureDockMode.EDIT) {
      Column()
        .id(`${TAG}_${direction}_${dockType}_${index}`)
        .border({ width: StyleConstants.SQUEEZE_BORDER_WIDTH, color: '#33ffffff' })
        .borderRadius(GestureDockConstants.GESTURE_DOCK_ICON_RADIUS)
        .width(GestureDockConstants.GESTURE_DOCK_ICON_SIZE)
        .height(GestureDockConstants.GESTURE_DOCK_ICON_SIZE)
        .margin({ top: GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / 2,
          bottom: GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / 2 })
        .backgroundColor('#0dffffff')
    }
  }

  @Styles
  editImageStyle() {
    .width(GestureDockConstants.GESTURE_DOCK_ICON_SIZE)
    .height(GestureDockConstants.GESTURE_DOCK_ICON_SIZE)
    .borderRadius(GestureDockConstants.GESTURE_DOCK_ICON_RADIUS)
    .margin({ bottom: GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE })
    .draggable(false)
  }

  @Styles
  checkImageStyle() {
    .width(GestureDockConstants.GESTURE_DOCK_ICON_SIZE)
    .height(GestureDockConstants.GESTURE_DOCK_ICON_SIZE)
    .draggable(false)
  }
}