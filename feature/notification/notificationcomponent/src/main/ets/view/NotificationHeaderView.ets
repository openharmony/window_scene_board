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

import { BaseGesture, DropdownVm, NotificationVmInjector, } from '@ohos/systemuicommon/newIndex';
import { EventManagerAdapter, NotificationSysEventReporter } from '@ohos/systemuicommon';
import { DateWeekVM } from '@ohos/customcomponent/src/main/ets/vm/DateWeekVM';
import { TimeVM } from '@ohos/customcomponent/src/main/ets/vm/TimeVM';
import { ViewCallback } from '@ohos/customcomponent/src/main/ets/vm/BaseVM';
import { DateUtils } from '@ohos/customcomponent/src/main/ets/common/DateUtils';
import { bundleManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { HiDfxEventUtil, obtainStartAbilityWithWant, TargetPanel } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ExtAppConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { NotificationApiUtil } from '../utils/NotificationApiUtil';
import Intl from '@ohos.intl';

const TAG = 'NotificationHeaderView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const NTF_TITLE_PADDING_TOP: Resource = $r('app.float.ntf_title_padding_top');
const NTF_TITLE_PADDING_BOTTOM: Resource = $r('app.float.ntf_title_padding_bottom');
const NTF_TITLE_DATE_MARGIN_TOP: Resource = $r('app.float.ntf_title_date_margin_top');
const NTF_DATA_PLAN_MARGIN_TOP: Resource = $r('app.float.ntf_data_plan_margin_top');

/**
 * 通知中心面板头部信息
 */
@ComponentV2
export struct NotificationHeaderView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;

  @Computed
  get headerVm() {
    const headerVm = this.ntfVmInjector.getHeaderVm?.();
    if (headerVm) {
      this.contentGesture.destroy();
      this.contentGesture.addGesture(headerVm?.getPanGestureHandler());
    }
    return headerVm;
  }

  @Computed
  get dataPlanVm() {
    return this.ntfVmInjector.getDataPlanVm()!;
  }

  @Computed
  get scrollVm() {
    return this.ntfVmInjector.getListScrollerVm();
  }

  @Computed
  get listVm() {
    return this.ntfVmInjector.getListVm();
  }

  @Computed
  get panelVm() {
    return this.ntfVmInjector.getPanelVm();
  }
  private colorVm = this.ntfVmInjector.getColorVm();
  private dropdownEvent = DropdownVm.instance.dropdownEvent;
  /**
   * VM
   */
  private timeVM: TimeVM = new TimeVM();
  /**
   * VM
   */
  private dateWeekVM: DateWeekVM = new DateWeekVM();
  /**
   * 记录当前的下拉面板状态
   */
  @Local target: TargetPanel = TargetPanel.NONE;
  @Local canTimeViewShow: boolean = false;
  /**
   * 日期文本
   */
  @Local dateText: string = '';
  @Local weekText: string = '';
  @Local dateWithoutYearText: string = '';
  /**
   * 时间文本
   */
  @Local timeText: string = '';
  @Local hoursText: string = '';
  @Local minuteText: string = '';

  @Local contentGesture: BaseGesture = new BaseGesture();

  private dateCallback: ViewCallback = {
    onTimeTextUpdate: (dateText: string): void => {
      this.dateText = dateText;
      this.setWeekAndDate();
    }
  };
  private timeCallback: ViewCallback = {
    onTimeTextUpdate: (timeText: string): void => {
      this.formatTime(timeText);
      this.setHoursAndMinute();
    }
  };

  private setHoursAndMinute(): void {
    if (this.timeText) {
      let times = this.timeText.split(':');
      if (times && times.length === 2) {
        this.hoursText = times[0];
        this.minuteText = times[1];
      }
    }
  }

  private setWeekAndDate(): void {
    this.weekText = DateUtils.formatDateNoMonthDay(new Date());
    this.dateWithoutYearText = DateUtils.formatDateNoWeek(new Date());
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear.`);

    // 初始化时获取一次时间，防止第一次由控制中心横滑时时间为空
    this.initTimeDateVM();
    this.destroyTimeDateVM();
    this.headerVm?.registerEventListener();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.headerVm?.unRegisterEventListener();
  }

  build() {
    Column() {
      this.buildTime()
      this.buildDateAndData()
    }
    .id(this.ntfVmInjector.getId(TAG))
    .align(Alignment.Center)
    .accessibilityLevel('no')
    .width(this.headerVm?.width)
    .padding({
      top: this.panelVm?.isLandscapeLayout ? 0 : NTF_TITLE_PADDING_TOP,
      bottom: this.panelVm?.isLandscapeLayout ? 0 : NTF_TITLE_PADDING_BOTTOM
    })
    .margin(this.headerVm?.margin)
    .gestureModifier(this.contentGesture)
    .onTouch((event: TouchEvent) => {
      if (event?.type === TouchType.Down) {
        DropdownVm.instance.updateStartPosition(event.touches[0].displayX, event.touches[0].displayY);
      } else if (event?.type === TouchType.Up) {
        DropdownVm.instance.updateEndPosition(event.touches[0].displayX, event.touches[0].displayY);
      }
    })
    .visibility(this.headerVm?.visibility)
    .translate({ y: this.headerVm?.headerTranslateY })
    .animation(this.headerVm?.followAnim)
    .alignRules(this.headerVm?.alignRules)
    .hitTestBehavior(HitTestMode.None)
    .zIndex(1)
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      if (this.headerVm) {
        this.headerVm.headerHeight = newValue.height as number;
      }
    })

  }

  @Builder
  buildTime() {
    if (this.panelVm?.isLandscapeLayout) {
      Column() {
        Text(this.hoursText)
          .id(this.ntfVmInjector.getId(`${TAG}_hoursView`))
          .timeCommonProperty()
          .textCommonProperty()
          .fontSize(this.headerVm?.timeTextFontSize)
          .fontWeight(this.headerVm?.timeTextFontWeight)
          .lineHeight(this.headerVm?.timeTextLineHeight)
          .accessibilityLevel('no')
        Text(this.minuteText)
          .id(this.ntfVmInjector.getId(`${TAG}_minuteView`))
          .timeCommonProperty()
          .textCommonProperty()
          .margin({ top: $r('app.float.ntf_land_time_margin_top') })
          .fontSize(this.headerVm?.timeTextFontSize)
          .fontWeight(this.headerVm?.timeTextFontWeight)
          .lineHeight(this.headerVm?.timeTextLineHeight)
          .accessibilityLevel('no')
      }
      .onClick(() => {
        this.jumpClockOrCalendar(ExtAppConstants.PKG_CLOCK)
      })
      .accessibilityText(this.timeText)
      .id(this.ntfVmInjector.getId(`${TAG}_TimeView_Text_timeText`))
    } else {
      Text(this.timeText)
        .id(this.ntfVmInjector.getId(`${TAG}_TimeView_Text_timeText`))
        .fontSize(this.headerVm?.timeTextFontSize)
        .fontWeight(this.headerVm?.timeTextFontWeight)
        .textAlign(TextAlign.Center)
        .timeCommonProperty()
        .textCommonProperty()
        .onClick(() => {
          this.jumpClockOrCalendar(ExtAppConstants.PKG_CLOCK)
        })
    }
  }

  @Builder
  buildDateAndData() {
    if (this.panelVm?.isLandscapeLayout) {
      Column() {
        Text(this.dateWithoutYearText)
          .id(this.ntfVmInjector.getId(`${TAG}_DayView_Text_dateText`))
          .fontSize(this.headerVm?.dateTextFontSize)
          .fontWeight(this.headerVm?.dateTextFontWeight)
          .lineHeight(this.headerVm?.dateTextLineHeight)
          .textCommonProperty()
          .dateCommonProperty()
        Text(this.weekText)
          .id(this.ntfVmInjector.getId(`${TAG}_WeekView_Text_dateText`))
          .fontSize(this.headerVm?.dateTextFontSize)
          .fontWeight(this.headerVm?.dateTextFontWeight)
          .lineHeight(this.headerVm?.dateTextLineHeight)
          .textCommonProperty()
          .dateCommonProperty()
          .margin({
            top: $r('app.float.ntf_land_date_weeks_margin_top')
          })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: $r('app.float.ntf_land_date_margin_top') })
      .onClick(() => {
        this.jumpClockOrCalendar(ExtAppConstants.PKG_CALENDAR)
      })
    } else {
      Column() {
        Text(this.dateText)
          .id(this.ntfVmInjector.getId(`${TAG}_DateWeekView_Text_dateText`))
          .fontSize(this.headerVm?.dateTextFontSize)
          .fontWeight(this.headerVm?.dateTextFontWeight)
          .margin({
            top: NTF_TITLE_DATE_MARGIN_TOP
          })
          .textCommonProperty()
          .onClick(() => {
            this.jumpClockOrCalendar(ExtAppConstants.PKG_CALENDAR)
          })
        this.buildData()
      }
      .dateCommonProperty()
      .padding({
        left: $r('app.float.ntf_list_item_padding_start_end'),
        right: $r('app.float.ntf_list_item_padding_start_end')
      })
    }
  }

  /**
   * 流量使用数据
   */
  @Builder
  buildData() {
    if (!this.panelVm.isLandscapeLayout && this.dataPlanVm.isShowDataPlan) {
      Row() {
        Row() {
          Text(`${this.dataPlanVm.todayUseDataText} |`)
            .id(this.dataPlanVm.getId(`todayUseData`))
            .fontSize(this.dataPlanVm?.dataTextFontSize)
            .fontWeight(this.dataPlanVm?.dataTextFontWeight)
            .textCommonProperty()
          Text(' ')
            .fontSize(this.dataPlanVm?.dataTextFontSize)
            .fontWeight(this.dataPlanVm?.dataTextFontWeight)
            .textCommonProperty()
          if (this.dataPlanVm.canDisplayAll) {
            Text(`${this.dataPlanVm.totalDataText} |`)
              .id(this.dataPlanVm.getId(`totalData`))
              .fontSize(this.dataPlanVm?.dataTextFontSize)
              .fontWeight(this.dataPlanVm?.dataTextFontWeight)
              .textCommonProperty()
            Text(' ')
              .fontSize(this.dataPlanVm?.dataTextFontSize)
              .fontWeight(this.dataPlanVm?.dataTextFontWeight)
              .textCommonProperty()
          }
          if (this.dataPlanVm.dataExceed()) {
            SymbolGlyph($r(`sys.symbol.exclamationmark_circle_fill`))
              .id(this.dataPlanVm.getId(`exceedSymbol`))
              .draggable(false)
              .fontSize(this.dataPlanVm?.dataTextFontSize)
              .renderingStrategy(SymbolRenderingStrategy.SINGLE)
              .fontColor([Color.White])
          }
          Text(this.dataPlanVm.dataExceed() ? ` ${this.dataPlanVm.remainDataText}` : `${this.dataPlanVm.remainDataText}`)
            .id(this.dataPlanVm.getId(`remainData`))
            .fontSize(this.dataPlanVm?.dataTextFontSize)
            .fontWeight(this.dataPlanVm?.dataTextFontWeight)
            .textCommonProperty()
            .width(this.dataPlanVm.remainTextWidth)
            .wordBreak(WordBreak.BREAK_ALL)
        }
        .accessibilityLevel('yes')
        .accessibilityText(this.dataPlanVm.accessibilityText)
        .onClick(() => {
          this.dataPlanVm.jumpToDataPage()
        })
      }
      .id(this.dataPlanVm.getId(`dataView`))
      .margin({
        top:  NTF_DATA_PLAN_MARGIN_TOP
      })
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
  }

  @Styles
  dateCommonProperty(){
    .foregroundBrightness(this.colorVm?.headerContentFgBrightness)
    .draggable(false)
    .clip(false)
    .scale({ x: this.headerVm?.dateTextScale, y: this.headerVm?.dateTextScale, centerY: '15%' })
    .opacity(this.headerVm?.dateTextOpacity)
    .translate({ y: this.headerVm?.dateTextTranslateY })
    .animation(this.headerVm?.followAnim)
  }

  @Styles
  timeCommonProperty(){
    .draggable(false)
    .foregroundBrightness(this.colorVm?.headerContentFgBrightness)
    .clip(false)
    .scale({ x: this.headerVm?.timeTextScale, y: this.headerVm?.timeTextScale, centerY: '0%' })
    .opacity(this.headerVm?.timeTextOpacity)
    .translate({ y: this.headerVm?.timeTextTranslateY })
    .animation(this.headerVm?.followAnim)
  }

  private initTimeDateVM(): void {
    this.dateWeekVM.init(TAG + '_DateWeekView', this.dateCallback);
    this.timeVM.initOv(false, TAG + '_TimeView', this.timeCallback);
    /* 直接通过 timeVM 获取时间会有构造 DateTimeFormat 及其销毁的过程，引过程耗时较长，因此通过解析来获取时间 */
    this.formatTime(this.timeVM.getCurrentTime());
    this.setHoursAndMinute();
    this.dateText = this.dateWeekVM.getCurrentDate();
    this.setWeekAndDate();
  }

  private destroyTimeDateVM(): void {
    this.dateWeekVM.onDestroy();
    this.timeVM.onDestroy();
  }

  private formatTime(time: string): void {
    if (time.length >= 5) {
      this.timeText = time;
    }
    const formatter: Intl.NumberFormat = new Intl.NumberFormat();
    this.timeText = time.padStart(5, formatter.format(0));
    // MemoryUtils.removeNapiWrap(formatter, false);
  }

  private jumpClockOrCalendar(packageName: string): void {
    let pkgEnabled: boolean;
    try {
      pkgEnabled = bundleManager.isApplicationEnabledSync(packageName);
    } catch (error) {
      let code: number = (error as BusinessError).code;
      log.showWarn('jumpClockOrCalendar Failed. error: ' + packageName + error);
      // 显式的得到时钟/日历未启用或被卸载时拦截点击操作，其余情况都保持原有逻辑予以放行
      pkgEnabled = (code !== 17700001);
    }
    if (pkgEnabled) {
      // 收起面板
      DropdownVm.instance.hidePanel(true);
      if (packageName === ExtAppConstants.PKG_CLOCK) {
        // 跳转时钟页面，使用ApiUtil中的方法，可以处理跨线程调用场景
        NotificationApiUtil.startClockMainAbility();
      } else if (packageName === ExtAppConstants.PKG_CALENDAR) {
        // 跳转日历页面，使用ApiUtil中的方法，可以处理跨线程调用场景
        NotificationApiUtil.startCalendarMainAbility();
      }
    }
    // 点击行为打点上报
    if (packageName === ExtAppConstants.PKG_CLOCK) {
      HiDfxEventUtil.reportNtfPanelClickTime();
      NotificationSysEventReporter.notificationPanelClock({
        TIME_STAMP: `${DropdownVm.instance.lastDropdownTime}`
      });
    } else if (packageName === ExtAppConstants.PKG_CALENDAR) {
      HiDfxEventUtil.reportNtfPanelClickDate();
      NotificationSysEventReporter.notificationPanelCalendar({
        TIME_STAMP: `${DropdownVm.instance.lastDropdownTime}`
      });
    }
  }

  @Monitor('dropdownEvent.target', 'dropdownEvent.targetChanged', 'dropdownEvent.progress')
  onDropdownChange(): void {
    log.info('onDropdownChange:', this.dropdownEvent);
    if (this.target !== this.dropdownEvent.target) {
      this.target = this.dropdownEvent.target;

      // 只有通知面板显示时，才更新时间和日期，防止后台冗余刷新。
      if (this.target === TargetPanel.NOTIFICATION_PANEL) {
        this.initTimeDateVM();
        if (DropdownVm.instance.isFromCCToNC) {
          // 从控制中心横滑切换到通知中心不需要动效
          this.headerVm?.showTitleText();
          this.dataPlanVm?.showDataText();
        } else {
          this.headerVm?.doTitleAnim(true);
          this.dataPlanVm?.doDataAnim(true);
        }
      } else {
        if (this.target === TargetPanel.CONTROL_CENTER_PANEL) {
          this.headerVm?.resetClockStatus();
        }
        this.destroyTimeDateVM();
      }
    } else if (!this.dropdownEvent.progress) {
      // 收起面板
      this.headerVm?.doTitleAnim(false);
    }
  }

  /**
   * 监听list出现滚动条下拉时，header跟随
   */
  @Monitor('scrollVm.currentOffsetY')
  scrollChange(): void {
    if (!this.scrollVm || !this.headerVm || !this.listVm) {
      return;
    }

    // 未下拉完成时不处理
    if (this.dropdownEvent.progress !== 1) {
      return;
    }
    if (this.target !== TargetPanel.NOTIFICATION_PANEL) {
      return;
    }

    let transY = 0;
    let firstCardTransY = 0;
    try {
      firstCardTransY = (this.scrollVm.scroller.getItemRect(0)?.y ?? 0) - this.listVm.contentStartOffset;
    } catch (e) {}
    if (!this.dataPlanVm.delayLoad) {
      this.headerVm.doFollowHandAnim(firstCardTransY);
      this.dataPlanVm.dataPlanDoFollowHandAnim(firstCardTransY);
    }
    // scroll处于下拉超过边界状态时，获取第一个card卡片的纵向位移 作为header区域的跟随位移
    if (this.scrollVm?.currentOffsetY < 0 && firstCardTransY > 0) {
      transY = firstCardTransY;
    }

    if (transY === 0 && this.dropdownEvent.moveY > 0) {
      this.headerVm.preDropDownMoveY = this.dropdownEvent.moveY;
      return;
    }
    this.headerVm.doFollowUpdateTransY(transY, this.dropdownEvent.moveY);
    this.dataPlanVm.dataPlanDoFollowUpdateTransY(transY, this.dropdownEvent.moveY);
    return;
  }
}

@Extend(Text)
function textCommonProperty() {
  .fontColor($r('app.color.ntf_phone_common_font_color'))
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
  .fontFeature('\"ss01\" on')
  .fontFamily('HarmonyHeiTi')
}