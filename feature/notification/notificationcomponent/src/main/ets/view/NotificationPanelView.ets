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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DropDownEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { NotificationHeaderView } from './NotificationHeaderView';
import { DropdownVm, NotificationVmInjector, LiveVmInjector } from '@ohos/systemuicommon/newIndex';
import { LiveDropdownVmInjector } from '@ohos/systemuicommon/src/main/ets/live/variant/dropdown/LiveDropdownVmInjector';
import { NotificationPanelVmInjectorFactory } from '../viewmodel/NotificationPanelVmInjectorFactory';
import { NotificationListView } from './NotificationListView';
import { NotificationClearButtonView } from './NotificationClearButtonView';
import { NotificationSettingDialogView } from './NotificationSettingDialogView';
import { NotificationStyle } from '../constants/NotificationStyle';
import { NotificationSilenceDialogView } from '@ohos/systemuicommon/src/main/ets/view/NotificationSilenceDialogView';

const TAG = 'NotificationPanelView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const BLUR_AREA_WIDTH = '200%';

/**
 * 通知中心面板
 */
@ComponentV2
export struct NotificationPanelView {
  private dropdownEvent: DropDownEvent = DropdownVm.instance.dropdownEvent;
  @Provider() ntfVmInjector: NotificationVmInjector = NotificationPanelVmInjectorFactory.get();
  @Provider() liveVmInjector: LiveVmInjector = LiveDropdownVmInjector.instance;
  @Param contentScale: number = 1;
  @Event changePosition: (val: number) => void = (val: number) => {
  };
  @Event onIsLandscapeLayoutChange: (isLandscapeLayout: boolean) => void = (isLandscapeLayout: boolean) => {};


  @Monitor('dropdownEvent.target', 'dropdownEvent.targetChanged', 'dropdownEvent.progress', 'dropdownEvent.moveY',
  'dropdownEvent.pullFraction', 'dropdownEvent.translateY', 'dropdownEvent.speedY', 'dropdownEvent.targetChangedMove',
  'dropdownEvent.source', 'dropdownEvent.speedX', 'dropdownEvent.isEndAnimRunning', 'dropdownEvent.eventType')
  dropDownEventChange(): void {
    if (this.panelVm && this.panelVm.onDropdownChange) {
      this.panelVm.onDropdownChange(this.dropdownEvent);
    }
  }

  @Computed
  get horizontalDropPanelPositionChange(): void {
    const horizontalDropPanelPosition = this.panelVm.horizontalDropPanelPosition;
    this.changePosition(horizontalDropPanelPosition ?? 0);
    return;
  }

  @Computed
  get panelVm() {
    return this.ntfVmInjector.getPanelVm();
  }

  @Computed
  get isLandscapeChange(): void {
    this.onIsLandscapeLayoutChange(this.panelVm.isLandscapeLayout);
    return;
  }

  @Styles
  gestureAttributes() {
    .gesture(GestureGroup(GestureMode.Exclusive,
      PanGesture({ direction: PanDirection.Vertical, distance: DropdownVm.VERTICAL_PAN_DISTANCE })
        .onActionStart(DropdownVm.instance.onPanVertical)
        .onActionUpdate(DropdownVm.instance.onPanVertical)
        .onActionEnd(DropdownVm.instance.onPanVerticalEnd)
        .onActionCancel(DropdownVm.instance.onPanVerticalCancel),
      PanGesture({ direction: PanDirection.Horizontal })
        .onActionStart(this.panelVm.onPanHorizontalStart)
        .onActionUpdate(this.panelVm.onPanHorizontalMove)
        .onActionEnd(this.panelVm.onPanHorizontalEnd)
        .onActionCancel(this.panelVm.onPanHorizontalCancel),
    ))
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.panelVm.listenEvent?.();
    this.ntfVmInjector.getListVm()?.init();
    LiveDropdownVmInjector.instance.init();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.ntfVmInjector.getListVm()?.destroy();
    this.ntfVmInjector.getSettingDiagVm()?.unInit();
    this.ntfVmInjector.clearVm();
    this.changePosition = () => {};
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      RelativeContainer() {
        NotificationHeaderView()
        NotificationListView()
        NotificationClearButtonView()
      }
      .id(TAG)
      .accessibilityLevel('no')
      .width('100%')
      .height('100%')
      .padding({ top: DropdownVm.instance.checkMoveDown() ? NotificationStyle.DROPDOWN_STATUS_BAR_HEIGHT : 0 })
      .opacity(this.panelVm.opacity)
      .scale({ x: this.panelVm.scale, y: this.panelVm.scale })
      .onVisibleAreaChange([0, 1], (isVisible: boolean, currentRatio: number) => {
        this.panelVm.onPanelVisibleChange(isVisible, currentRatio);
      })
      .enabled(this.panelVm.isResponsive)
      .gestureAttributes()
      .onClick((event) => {
        log.showInfo('onClick, hide panel');
        this.ntfVmInjector.getListVm()?.onClick(event);
      })
      .onTouch(this.panelVm.onTouchEvent)

      NotificationSettingDialogView();
      NotificationSilenceDialogView();
      this.buildHeadBlurArea();
    }
  }
  @Builder
  buildHeadBlurArea() {
    Column() {
      Column()
        .width(BLUR_AREA_WIDTH)
        .height(this.panelVm.blurAreaHeight)
        .compositingFilter(this.panelVm.getBlurCompositingFilter?.())
        .blendMode(6)
    }
    .width(BLUR_AREA_WIDTH)
    .height(this.panelVm.blurAreaHeight)
    .translate({
      y: this.panelVm.blurAreaTransY
    })
    .linearGradient({
      angle: 270, colors: [['rgba(0, 0, 0, 1)', 0],
        ['rgba(0, 0, 0, 1)', 0.8],
        ['rgba(0, 0, 0, 0)', 1]]
    })
    .blendMode(4, BlendApplyType.OFFSCREEN) // 启离屏
    .visibility(this.panelVm.isBlurAreaVisible ? Visibility.Visible : Visibility.Hidden)
    .accessibilityLevel('yes')
  }
}

@Builder
export function NotificationPanelViewBuilder() {
  NotificationPanelView()
}