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
  DateManager,
  DayData,
  DayLayout,
  SingleDayViewModel,
  SingleMonthViewModel,
  YearViewLayout,
  YearViewLayoutManager
} from '../calendar/PanelMonthViewModel';
import { ConfigurationEvent, DeviceHelper, EventManager, EvtBus, PluginSlot } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import BlendModeUtil from '../calendar/BlendModeUtil';
import { ExtAppConstants } from '@ohos/commonconstants';
import { bundleManager, ConfigurationConstant } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { StartAbilityUtil, windowMgr } from '@ohos/windowscene';
import Prompt from '@ohos.promptAction';
import { LengthMetrics } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import { DAY_PER_WEEK, HOURS_PER_DAY, MILLS_PER_HOUR } from '../calendar/DateUtil';

const TAG: string = '[MonthlyView][SigMonth]';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 基于月视图基础组件封装的业务组件，包含了Swiper无限下拉获取数据并基于月视图基础组件进行展示的逻辑
 *
 * @since 2023-08-16
 */
@Component
export struct SingleMonthlyView {
  // 月视图绑定的视图模型
  @ObjectLink viewModel: SingleMonthViewModel;
  // 月视图绑定的布局参数
  @State layout: YearViewLayout = YearViewLayoutManager.getInstance().layout;
  // 月视图绑定的布局参数
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private eventMgr: EventManager = EvtBus.createEventManager();
  @State isRootLoad: boolean = false;
  private clearSelectHandler: () => void = (): void => {
  };

  aboutToAppear() {
    this.eventMgr.on(ConfigurationEvent, (event: ConfigurationEvent) => {
      this.onLanguageChange();
      this.onDarkModeChange(event);
    });
  }

  aboutToDisappear() {
    this.eventMgr.offAll();
  }

  onDarkModeChange(event: ConfigurationEvent): void {
    let currColorMode = event.config?.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? 0 : 1;
    log.showInfo(`onDarkModeChange currColorMode: ${currColorMode}`);
    this.viewModel.onColorModeChange(currColorMode);
  }

  onLanguageChange() {
    this.viewModel.onLanguageChange();
  }

  updateMonthViewHeight(isWeekShow: boolean): number {
    return !isWeekShow ? this.layout.maxHeight :
    this.layout.minHeight;
  }

  private isWeekEnd(index: number):boolean {
    return this.viewModel.weekends.includes((index + this.viewModel.startOfWeek) % 7);
  }

  build() {
    Column() {
      if (this.isRootLoad) {
        Grid() {
          ForEach(this.viewModel.weekTitles, (title: string, index: number) => {
            GridItem() {
              Text(title)
                .fontSize('14vp')
                .textAlign(TextAlign.Center)
                .lineHeight('20vp')
                .fontWeight(FontWeight.Medium)
                .fontColor(this.colorModeViewData.wifiOffTextColor)
                .foregroundBrightness(this.isWeekEnd(index) ? undefined :
                this.colorModeViewData.foregroundPrimaryOption)
                .advancedBlendMode(this.isWeekEnd(index) ? BlendModeUtil.getBlenderTertiary() :
                  undefined);
            };
          });
        }
        .height(24)
        .padding({
          left: this.layout.margin,
          right: this.layout.margin,
        })
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')

        Grid() {
          ForEach(new Array(this.viewModel.weekNum * 7).fill(''),
            (item: string, index: number) => {
              if (this.viewModel.isWeekView(index)) {
                GridItem() {
                  SingleDayView({
                    viewModel: this.viewModel.dayViewModels[index],
                    clearSelectHandler: this.clearSelectHandler,
                  })
                }
                .focusable(true)
              }
            }, (item: string, index: number) => index.toString())
        }
        .height(this.updateMonthViewHeight(this.viewModel.isWeekShow))
        .padding({
          left: this.layout.margin,
          right: this.layout.margin,
          bottom: !this.viewModel.isWeekShow ? $r('sys.float.padding_level3') : $r('sys.float.padding_level8'),
          top: !this.viewModel.isWeekShow ? $r('sys.float.padding_level3') : $r('sys.float.padding_level4'),
        })
        .maxCount(1)
        .focusable(true)
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
        .rowsTemplate(this.viewModel.getRowsTemplate())
      }
    }
    .width('100%')
    .borderRadius(16)
    .onAppear(() => {
      this.isRootLoad = true;
    })
  }
}

@Component
export struct SingleDayView {
  // 月视图 单天视图 绑定的视图模型
  @ObjectLink viewModel: SingleDayViewModel;
  // 单天视图绑定的布局参数
  @State layout: DayLayout = YearViewLayoutManager.getInstance().dayLayout;
  // 月视图绑定的布局参数
  @State monthLayout: YearViewLayout = YearViewLayoutManager.getInstance().layout;
  // 点击条目的具体显示时间
  @State clickDate: number = 0;
  @State isHover: boolean = false;
  private readonly DELAY: number = 100;
  private clearSelectHandler: () => void = (): void => {
  };

  @Builder
  buildCircle() {
    if (this.viewModel.isSelect && this.viewModel.isToday && this.viewModel.recessText) {
      Image($r('app.media.calendar_select_01'))
        .width(this.layout.width)
        .height(this.layout.height)
        .fillColor(this.layout.circleColor);
    } else if (this.viewModel.isSelect && this.viewModel.recessText) {
      Image($r('app.media.calendar_select_02'))
        .width(this.layout.width)
        .height(this.layout.height)
        .fillColor(this.layout.circleColor);
    } else {
      Circle({
        width: this.layout.circleSize,
        height: this.layout.circleSize
      })
        .fill(this.layout.circleColor)
        .fillOpacity(this.viewModel.isToday ? 1 : 0)
        .strokeWidth(this.layout.circleLine)
        .stroke(this.layout.circleColor);
    }
  }

  @Builder
  buildDayText() {
    // 公历日期
    Text('' + this.viewModel.day) {
    }
    .margin({ top: 0 })
    .padding({ top: 0 })
    .textAlign(TextAlign.Center)
    .width(this.layout.solarFontWidth)
    .height(this.layout.solarFontHeight)
    .fontSize(this.layout.solarFontSize + 'vp')
    .fontWeight(this.layout.solarFontWeight)
    .markAnchor({
      x: this.layout.solarFontWidth / 2,
      y: this.layout.solarFontHeight / 2
    })
    .position({
      x: this.layout.width / 2,
      y: (this.viewModel.showLunar ?
        ((this.layout.height / 2 - this.layout.solarFontHeight / 2) + this.layout.verticalGap)
        : this.layout.height / 2)
    })
    .fontColor(this.viewModel.textColor)
    .foregroundBrightness(this.viewModel.textForegroundBrightness)
    .advancedBlendMode(this.viewModel.textAdvancedBlendMode)
  }

  // 节假日
  @Builder
  buildHoliday() {
    Text(this.viewModel.tagText)
      .textAlign(TextAlign.Center)
      .width(this.layout.calOrHolFontWidth)
      .height(this.layout.calOrHolFontHeight)
      .fontSize(this.layout.calOrHolFontSize + 'vp')
      .markAnchor({
        x: this.layout.calOrHolFontWidth / 2,
        y: this.layout.calOrHolFontHeight / 2
      })
      .position({
        x: this.layout.width / 2,
        y: !this.viewModel.showLunar ?
          (this.layout.height / 2 + this.layout.calOrHolFontHeight / 2) +
          this.layout.verticalGap + 4
          : (this.layout.height / 2 + this.layout.calOrHolFontHeight / 2) +
          this.layout.verticalGap
      })
      .fontColor(this.viewModel.tagTextColor)
  }

  // 历法
  @Builder
  buildCalendar() {
    Text(this.viewModel.tagText)
      .textAlign(TextAlign.Center)
      .width(this.layout.calOrHolFontWidth)
      .height(this.layout.calOrHolFontHeight)
      .fontSize(this.layout.calOrHolFontSize + 'vp')
      .markAnchor({
        x: this.layout.calOrHolFontWidth / 2,
        y: this.layout.calOrHolFontHeight / 2
      })
      .position({
        x: this.layout.width / 2,
        y: !this.viewModel.showLunar ?
          (this.layout.height / 2 + this.layout.calOrHolFontHeight / 2) +
          this.layout.verticalGap + 4
          : (this.layout.height / 2 + this.layout.calOrHolFontHeight / 2) +
          this.layout.verticalGap
      })
      .fontColor(this.viewModel.tagTextColor)
      .foregroundBrightness(this.viewModel.tagTextForegroundBrightness)
      .advancedBlendMode(this.viewModel.tagTextAdvancedBlendMode)
  }

  // 班休
  @Builder
  buildRecessText() {
    Text(this.viewModel.recessText)
      .textAlign(TextAlign.Center)
      .width(this.layout.recessWidth)
      .height(this.layout.recessHeight)
      .fontSize(`${this.layout.recessFontSize}vp`)
      .markAnchor({
        x: 0,
        y: 0
      })
      .position({
        x: this.layout.width - this.layout.recessWidth - this.layout.recessFontSize / 2,
        y: 0
      })
      .fontColor(this.viewModel.recessTextColor)
  }

  aboutToAppear(): void {
    this.viewModel.initCompId(); // 初始化 CompId
  }

  build() {
    Stack() {
      if (this.viewModel.isSelect) {
        this.buildCircle();
      }
      Column() {
        this.buildDayText();
        if (this.viewModel.hasFestivals) {
          this.buildHoliday();
        } else {
          this.buildCalendar();
        }
        if (this.viewModel.showRecessData) {
          this.buildRecessText();
        }
      }
      .onHover((isHover: boolean) => {
        this.isHover = isHover;
      })
      .bindPopup(this.isHover && this.viewModel.isShowPopUp, {
        builder: this.hoverTipsBuilder(),
        placement: Placement.Bottom,
        mask: false,
        enableArrow: false,
        autoCancel: true,
        showInSubWindow: true,
        radius: $r('sys.float.corner_radius_level4'),
        shadow: ShadowStyle.OUTER_DEFAULT_SM,
        backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
        offset: { y: 0 },
        targetSpace: $r('sys.float.padding_level4'),
      })
      .width(this.layout.width)
      .height(this.layout.height)
    }
    .width(this.layout.width)
    .height(this.layout.height)
    .onClick(() => {
      this.onClickSingleDay();
    })
    .id(this.viewModel.compId)
    .focusable(true)
    .focusBox({
      margin: LengthMetrics.vp(-1)
    })
    .focusOnTouch(true)
    .onKeyEvent((event: KeyEvent) => {
      this.onKeyEventHandle(event);
    })
  }

  @Builder
  hoverTipsBuilder() {
    Row() {
      Text(this.viewModel.popupContent)
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_primary'))
        .draggable(false)
        .fontWeight(FontWeight.Regular)
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .align(Alignment.Center)
    }
    .justifyContent(FlexAlign.Center)
    .padding($r('sys.float.padding_level4'))
  }

  onClickSingleDay() {
    const dayData: DayData = this.viewModel.dayData;
    if (dayData === null || dayData === undefined) {
      log.showError('onClickSingleDay NO VALID DATE INFO TO BUILD DAY!');
      return;
    }
    if (this.viewModel.isSelect) {
      this.jumpToCalendar(dayData);
    } else {
      this.changeSelectDay(dayData);
    }
  }
  /**
   * 处理键盘操作
   * @param event 传入的键盘事件
   */
  private onKeyEventHandle(event: KeyEvent){
    let selectDayTimeStamp = DateManager.getInstance().selectedDay.getDate().getTime();
    if (event.keyCode === KeyCode.KEYCODE_DPAD_UP && event.type === KeyType.Down) {
      selectDayTimeStamp = selectDayTimeStamp - DAY_PER_WEEK * HOURS_PER_DAY * MILLS_PER_HOUR;
      event.stopPropagation();
    } else if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN && event.type === KeyType.Down) {
      selectDayTimeStamp = selectDayTimeStamp + DAY_PER_WEEK * HOURS_PER_DAY * MILLS_PER_HOUR;
      event.stopPropagation();
    } else if (event.keyCode === KeyCode.KEYCODE_DPAD_LEFT && event.type === KeyType.Down) {
      selectDayTimeStamp = selectDayTimeStamp - HOURS_PER_DAY * MILLS_PER_HOUR;
      event.stopPropagation();
    } else if (event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT && event.type === KeyType.Down) {
      selectDayTimeStamp = selectDayTimeStamp + HOURS_PER_DAY * MILLS_PER_HOUR;
      event.stopPropagation();
    }

    let selectDay: Date = new Date(selectDayTimeStamp);
    let selectDayData: DayData = new DayData(selectDay.getFullYear(), selectDay.getMonth() + 1, selectDay.getDate());
    this.changeSelectDay(selectDayData);

    // 周视图键盘切换选中天到下周后，会重新创建视图，添加延时让焦点在当前选中天上
    if (this.viewModel.isWeekView) {
      let selectId = `singleDayView_${selectDay.getFullYear()}_${selectDay.getMonth() + 1}_${selectDay.getDate()}`;
      if (event.keyCode === KeyCode.KEYCODE_DPAD_UP || event.keyCode === KeyCode.KEYCODE_DPAD_DOWN ||
        event.keyCode === KeyCode.KEYCODE_DPAD_LEFT || event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
        setTimeout(() => {
          focusControl.requestFocus(selectId);
        }, this.DELAY);
      }
    }
  }

  changeSelectDay(dayData: DayData) {
    DateManager.getInstance().selectedDay = dayData;
    this.clearSelectHandler();
  }

  jumpToCalendar(dayData: DayData) {
    const packageName = ExtAppConstants.PKG_CALENDAR;
    let pkgEnabled: boolean;
    try {
      pkgEnabled = bundleManager.isApplicationEnabledSync(packageName);
    } catch (error) {
      let code: number = (error as BusinessError).code;
      log.showWarn(`jumpToCalendar Failed.error ${packageName} ${error}`);
      // 日历被卸载时拦截点击操作，其余情况都保持原有逻辑予以放行
      pkgEnabled = (code !== 17700001);
      Prompt.showToast({
        message: $r('app.string.install_app_calendar'),
      });
    }
    if (pkgEnabled) {
      windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL);
      StartAbilityUtil.startAbilityFromOther({
        bundleName: ExtAppConstants.PKG_CALENDAR,
        abilityName: ExtAppConstants.ABILITY_CALENDAR,
        moduleName: ExtAppConstants.MODULE_CALENDAR,
        parameters: {
          action: 'CLICK_MONTH_FORM_HEADER',
          tabIndex: '1',
          year: dayData.solarYear,
          month: dayData.solarMonth - 1,
          day: dayData.solarDay
        }
      });
    }
  }
}