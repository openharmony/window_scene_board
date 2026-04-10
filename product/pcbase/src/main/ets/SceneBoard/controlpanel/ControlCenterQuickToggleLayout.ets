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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { DeviceHelper, ConfigurationEvent, EvtBus } from '@ohos/frameworkwrapper';
import StyleConfiguration, { ControlCenterQuickToggleLayoutStyle } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/StyleConfiguration';
import { QuickToggleController } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/QuickToggleController';
import { ControlCenterData, ToggleData } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/Constants';
import { CommonData } from '@ohos/controlcentercommon/Index';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import Brightness from '@ohos/controlcentercomponent/src/main/ets/com/ohos/pages/newStyle/Brightness';
import Volume from './volumeslider/pages/Volume';
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterLayoutController';
import { ControlListController } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlListController';
import { ControlCenterHomeViewData } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/vm/ControlCenterHomeViewData';
import { AddMoreToggleButton } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/view/AddMoreToggleButton';
import sControlCenterController from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterController';
import { AnimationDataArray } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/model/ControlCenterAnimationData';
import { BrightnessSharedViewData } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/viewModel/BrightnessViewModel';
import { BackgroundOpacity } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/model/BrightnessViewData';
import { LengthMetrics } from '@kit.ArkUI';
import { ToggleTemplateType } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { ToggleComponent } from '@ohos/controlcentercommon/src/main/ets/toggle/view/NewToggleBaseComponent';
import { PCToggleFactory } from './pcStyle/PCStyleFactory';
import { ToggleScene } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';

const TAG = 'Ctrl.QuickToggleLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

const BRIGHTNESS_AREA = 1;
const HEIGHT_OFFSET = 4;
const FOCUS_OFFSET = 2;

@Component
export default struct ControlCenterQuickToggleLayout {
  @State viewData?: ControlCenterHomeViewData = sControlCenterController.getHomeViewData();
  @State toggleColumn: number = QuickToggleController.getInstance().getToggleColumn();

  @State quickToggleColumn: number = QuickToggleController.getInstance().getQuickToggleColumn();
  @StorageLink('QuickToggleData') @Watch('handleToggleDataChanged') toggleData: ToggleData = QuickToggleController.getInstance().getToggleData();
  private style: ControlCenterQuickToggleLayoutStyle = StyleConfiguration.getControlCenterQuickToggleLayoutStyle();
  @State isTogglePanelExpand: boolean = false;
  isPC: boolean = DeviceHelper.isPC();
  @StorageLink('DarkModeModel_DarkModeStatus') @Watch('onDarkModeChanged') darkModeData: CommonData = new CommonData();
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false;
  @Consume @Watch('onLayoutChange') ccLayoutIndex: ControlCenterLayoutIndex;
  @Link animationDataArray: AnimationDataArray;
  private isShowDivider: boolean = false;
  private isHideQuickToggle: boolean = true;

  /**
   * 快捷开关高度
   */
  @State totalHeight: number = 0;

  /**
   * grid高度
   */
  @State gridHeight: number = 0;

  /**
   * 快捷开关第一行button的宽度
   */
  @State buttonWidth: number = 0;

  /**
   * grid开关的数据
   */
  @State gridButtons: Array<string> = [];

  /**
   * 折叠时button宽度
   */
  buttonWidthStart: number = 0;

  /**
   * 展开时button宽度
   */
  buttonWidthEnd: number = 0;

  /**
   * 亮度条以及展开图像高度
   */
  brightnessHeight: number = 0;
  startY: number = 0;

  /**
   * 快捷开关除第一行外的最大行数
   */
  @State maxRowCount: number = 0;

  /**
   * 快捷开关最大高度
   */
  maxHeight: number = 0;

  /**
   * 快捷开关最小高度
   */
  minHeight = 0;
  isExpandReachEnd = false;

  /**
   * 快捷开关数组
   */
  toggles: string[] = [];

  /**
   * 列表滑动控制器
   */
  private listController?: ControlListController;

  /**
   * Control Center Parameters
   */
  @Link controlCenterArea: number;
  @Link controlCenterQuickHeight: number;
  private areaIndex: number = 0;

  /**
   * 控制中心数据
   */
  @State data: ControlCenterData = sControlCenterController.getData();

  @State backgroundOpacity: BackgroundOpacity = BrightnessSharedViewData.getInstance().getBackgroundOpacity();

  // grid空白区域面积，根据开关布局动态调整，点击该空白区域会收起面板
  @State blankAreaPositionX: number = 0;
  @State blankAreaPositionY: number = 0;
  @State blankAreaWidth: number = 0;
  @State blankAreaHeight: number = 0;

  private getVisibility(): Visibility {
    if (this.data.state === ControlCenterState.MAIN_LAYOUT &&
      this.backgroundOpacity.backgroundOpacity === 0 &&
      this.isHideQuickToggle) {
      // 滑动亮度条时隐藏
      return Visibility.Hidden;
    } else {
      // 其他场景的默认显示，并受mainLayout的visibility属性的统一控制
      return Visibility.Visible;
    }
  }

  getBrightnessVisibility(): Visibility {
    return CC_LAYOUT_CONFIGS[this.ccLayoutIndex].showBrightnessUnderToggles ?
      Visibility.Visible : Visibility.Hidden;
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear, toggleData: ${this.toggleData.toString()}`);
    this.initGrid();
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisAppear`);
  }

  /**
   * 初始化Grid
   */
  initGrid() {
    this.toggles = Array.from(this.toggleData.quickToggle);
    this.gridButtons = [];
    for (let i = 0; i < this.toggles.length; i++) {
      this.gridButtons.push(this.toggles[i]);
    }
    this.maxRowCount = Math.ceil(this.gridButtons.length / this.toggleColumn);
    let rowHeight = this.style.buttonDiameter + this.style.buttonLabelSpace +
      this.style.buttonLabelHeight + this.style.buttonMarginBottom + this.style.newIconPadding;
    this.gridHeight = rowHeight * this.maxRowCount;
    let showBrightnessUnderToggles: boolean = CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.showBrightnessUnderToggles;
    this.controlCenterArea = this.maxRowCount + (showBrightnessUnderToggles ? BRIGHTNESS_AREA : 0);
    this.controlCenterQuickHeight = !showBrightnessUnderToggles ? this.gridHeight :
      this.gridHeight + this.style.brightnessTopMargin + this.style.brightnessHeight * 2 +
        this.style.brightnessPadding * 4 + this.style.additionalQuickHeight - HEIGHT_OFFSET;
    this.countBlankArea();
  }

  countBlankArea() {
    let remainderGridNum = this.toggles.length % 4;
    if (remainderGridNum === 0) {
      this.blankAreaWidth = 0;
      this.blankAreaHeight = 0;
      return;
    }
    let gridItemHeight: number = this.style.buttonDiameter + this.style.buttonLabelSpace + this.style.buttonLabelHeight;
    this.blankAreaPositionX = remainderGridNum * this.style.buttonDiameter +
      (remainderGridNum - 1) * this.style.buttonMargin;
    this.blankAreaPositionY = (this.maxRowCount - 1) * gridItemHeight +
      (this.maxRowCount - 2) * this.style.buttonMarginBottom;
    this.blankAreaWidth = this.getGridWidth() as number - this.blankAreaPositionX;
    this.blankAreaHeight = gridItemHeight + this.style.buttonMarginBottom * 2;
  }

  build() {
    Column() {
      if (this.viewData?.replaceBrightnessBar) {
        AddMoreToggleButton()
          .margin({ top: this.style.brightnessTopMargin })
      } else {
        this.buildBrightnessBar()
        this.buildVolumeBar()
      }

      this.buildGrid()
    }
  }

  @Builder
  buildVolumeBar() {
    Volume({
      animationData: this.animationDataArray[this.areaIndex + this.maxRowCount],
      isLandscapeBrightness: false
    })
      .padding({
        top: $r('app.float.Control_center_brightness_padding_top'),
        bottom: $r('app.float.Control_center_brightness_padding_bottom'),
        start: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_volume_bright_padding')))
      })
      .margin({ top: $r('app.float.Control_center_volume_top_margin') })
      .width('100%')
      .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex].showBrightnessUnderToggles ?
        this.style.brightnessHeight + FOCUS_OFFSET * 2 : 0)
      .visibility(this.getBrightnessVisibility())
  }

  @Builder
  buildBrightnessBar() {
    Brightness({
      animationData: this.animationDataArray[this.areaIndex + this.maxRowCount],
      isLandscapeBrightness: false,
      brightnessFocusable: true,
    })
      .padding({
        top: $r('app.float.Control_center_brightness_padding_top'),
        bottom: $r('app.float.Control_center_brightness_padding_bottom'),
        start: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_volume_bright_padding'))),
        end: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_volume_bright_padding')))
      })
      .margin({ top : this.style.brightnessTopMargin })
      .width('100%')
      .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex].showBrightnessUnderToggles ?
        this.style.brightnessHeight + FOCUS_OFFSET * 2 : 0)
      .visibility(this.getBrightnessVisibility())
  }

  private getRowIndex(index: number) {
    return Math.floor(index / this.toggleColumn);
  }

  @Builder
  buildGrid() {
    Grid() {
      ForEach(this.gridButtons, (slot: string, index: number) => {
        GridItem() {
          ToggleComponent({
            toggleId: slot,
            toggleViewModel: QuickToggleController.getInstance().createToggleModelAndInit(slot),
            toggleStyle: PCToggleFactory.getInstance().createBasicStyle(),
            templateType: ToggleTemplateType.BASIC,
            toggleScene: ToggleScene.PC
          })
        }
      }, (slot: string) => slot)
    }
    .visibility(this.getVisibility())
    .padding({
      top: $r('app.float.Control_center_quickToggle_padding_vertical_top'),
    })
    .rowsGap(this.style.quickToggleRowsGap)
    .columnsGap(this.style.quickToggleColumnsGap)
    .clip(false)
    .height((this.gridHeight as number) +
      this.style.quickToggleGridBottom)
    .margin({
      bottom: this.style.gridMarginBottom,
      left: this.style.gridMarginLeft,
      right: this.style.gridMarginRight
    })
    .columnsTemplate(QuickToggleController.getInstance().getToggleGridTemplate(this.toggleColumn))
    .rowsTemplate(QuickToggleController.getInstance().getToggleGridTemplate(Math.ceil(this.gridButtons.length /
      this.toggleColumn)))
  }

  private getGridWidth(): Length {
    return this.toggleColumn * (this.style.buttonMargin + this.style.buttonDiameter) -
    this.style.buttonMargin + this.style.pluginPadding * 2;
  }

  onDarkModeChanged(): void {
  }

  /**
   * 开关数据变化回调
   */
  handleToggleDataChanged() {
    log.showInfo(`handleToggleDataChanged, toggleData: ${this.toggleData.toString()}`);
    let after = this.toggleData.quickToggle.join(',');
    let before = this.toggles.join(',');
    if (after != before) {
      this.initGrid();
    }
  }

  /**
   * 布局切换回调
   */
  onLayoutChange() {
    log.showInfo(`onLayoutChange: ${this.ccLayoutIndex}`);
    this.toggleColumn = CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.toggleColumns;
    let showBrightnessUnderToggles: boolean = CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.showBrightnessUnderToggles;
    this.controlCenterArea = this.maxRowCount + (showBrightnessUnderToggles ? BRIGHTNESS_AREA : 0);
    this.controlCenterQuickHeight = !showBrightnessUnderToggles ? this.gridHeight :
      this.gridHeight + this.style.brightnessTopMargin + this.style.brightnessHeight +
        this.style.brightnessPadding * 2 + this.style.additionalQuickHeight;
  }
}