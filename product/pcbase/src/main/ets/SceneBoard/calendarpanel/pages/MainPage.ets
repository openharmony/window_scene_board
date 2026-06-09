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

import i18n from '@ohos.i18n';
import intl from '@ohos.intl';
import HashMap from '@ohos.util.HashMap';
import { PluginSlot, DeviceHelper } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { windowMgr, StartAbilityUtil, } from '@ohos/windowscene';
import { ExtAppConstants } from '@ohos/commonconstants';
import { PanelMonthViewModel } from '../calendar/PanelMonthViewModel';
import { ReportHiEventParams, ReportUtil } from '../calendar/HiSysCalendarReportUtil';
import Constants from '../../../common/constants/StatusBarPanelConstants';
import { curves, LengthMetrics } from '@kit.ArkUI';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { SwiperMonthlyView } from './SwiperMonthlyView';
import commonEventManager from '@ohos.commonEventManager';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'CalendarPanel-MainPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const COMPONENT_ID_CALENDAR = TAG + '_Calendar_calendar';
const COMPONENT_ID_ARROW_PRE = TAG + '_Image_arrow_pre';
const COMPONENT_ID_ARROW = TAG + '_Image_arrow';
const COMPONENT_ID_YEAR_MONTH = TAG + '_Text_yearAndMonth';
const COMPONENT_ID_TEXT_SETTING = TAG + '_Text_setting';

enum UpdateState {
  DEFAULT_STATE = 0,
  NEXT_MONTH_STATE = 1,
  PRE_MONTH_STATE = 2
}

interface EventSubscribeInfo {
  events: Array<string>;
}

@Component
export default struct MainPage {
  @State textColor: string | Resource = '#00000000';
  // 是否使用24小时制
  @State is24HourFormat: boolean = false;
  @State dateAndTimerHover: boolean = false;
  @State dateArrowLeftHover: boolean = false;
  @State dateArrowRightHover: boolean = false;
  // 状态栏月视图是否显示
  @Link @Watch('onCalendarStatus') isAssemblyPanelShow: boolean;
  // 节流函数触发的最小时间间隔
  private readonly DELAY: number = 200;
  private runningMap: HashMap<string, number> = new HashMap(); //防抖tag表
  // 月份切换箭头大小
  private readonly ARROW_SIZE: number = 40;
  private dateSettingMargin: number = 5;
  @State monthViewModel: PanelMonthViewModel = new PanelMonthViewModel();
  @Link isCollapse: boolean;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  updateHeight: () => void = () => {
  };
  private paddingStart: number = 4;
  private paddingEnd: number = 6;
  private subscriber: commonEventManager.CommonEventSubscriber | null = null;

  onCalendarStatus() {
    log.showInfo('onCalendarStatus calendarStatus: ' + this.isAssemblyPanelShow);
    if (this.isAssemblyPanelShow) {
      this.monthViewModel.updateIsChinaRegion();
      this.refreshDate();
      setTimeout(() => {
        focusControl.requestFocus(Constants.COMPONENT_ID_NTF_MANAGER);
      }, 100);
    }

    let params: ReportHiEventParams = {
      STATUS: this.isAssemblyPanelShow ? 'open' : 'close'
    };
    ReportUtil.reportBehaviorEvent(ReportUtil.calendarPanelChange, params);
  }

  @Builder
  dateArrowLeft() {
    Row() {
      SymbolGlyph($r('sys.symbol.chevron_right'))
        .rotate({ y: 1, angle: 180 })
        .fontSize($r('sys.float.ohos_id_text_size_headline6'))
        .fontWeight(FontWeight.Medium)
        .fontColor([this.colorModeViewData.wifiOffTextColor])
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
    }
    .id(COMPONENT_ID_ARROW_PRE)
    .height(this.ARROW_SIZE)
    .width(this.ARROW_SIZE)
    .borderRadius(this.ARROW_SIZE)
    .hoverEffect(HoverEffect.Highlight)
    .onClick(this.throttle(() => {
      this.jumpMonth(UpdateState.PRE_MONTH_STATE);
    }, this.DELAY))
    .onHover((isHover: boolean) => {
      this.dateArrowLeftHover = isHover;
    })
    .stateStyles({
      normal: {
        .border({ width: '2vp', color: '#00000000' })
        .backgroundColor(Color.Transparent)
      },
      focused: {
        .border({ width: '2vp', color: $r('sys.color.interactive_focus'), })
        .backgroundColor(this.dateArrowLeftHover ? $r('sys.color.interactive_hover') : this.textColor)
      },
      pressed: {
        .border({ width: '2vp', color: '#00000000' })
        .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
      }
    })
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  dateArrowRight() {
    Row() {
      SymbolGlyph($r('sys.symbol.chevron_right'))
        .fontSize($r('sys.float.ohos_id_text_size_headline6'))
        .fontWeight(FontWeight.Medium)
        .fontColor([this.colorModeViewData.wifiOffTextColor])
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
    }
    .id(COMPONENT_ID_ARROW)
    .height(this.ARROW_SIZE)
    .width(this.ARROW_SIZE)
    .borderRadius(this.ARROW_SIZE)
    .hoverEffect(HoverEffect.Highlight)
    .justifyContent(FlexAlign.Center)
    .onClick(this.throttle(() => {
      this.jumpMonth(UpdateState.NEXT_MONTH_STATE);
    }, this.DELAY))
    .onHover((isHover: boolean) => {
      this.dateArrowRightHover = isHover;
    })
    .stateStyles({
      normal: {
        .border({ width: '2vp', color: '#00000000' })
        .backgroundColor(Color.Transparent)
      },
      focused: {
        .border({ width: '2vp', color: $r('sys.color.interactive_focus'), })
        .backgroundColor(this.dateArrowRightHover ? $r('sys.color.interactive_hover') : this.textColor)
      },
      pressed: {
        .border({ width: '2vp', color: '#00000000' })
        .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
      }
    })
  }

  @Builder
  dateTitle() {
    Row() {
      Row() {
        this.dateArrowLeft();

        Text(this.formatDate(this.monthViewModel.displayYear, this.monthViewModel.displayMonth))
          .draggable(false)
          .id(COMPONENT_ID_YEAR_MONTH)
          .fontSize($r('sys.float.ohos_id_text_size_headline8'))
          .fontWeight(FontWeight.Bold)
          .fontFamily('sans-serif-condensed')
          .focusable(false)
          .fontColor(this.colorModeViewData.wifiOffTextColor)
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
          .padding({
            start: LengthMetrics.vp(this.paddingStart),
            end: LengthMetrics.vp(this.paddingEnd),
          });

        this.dateArrowRight();
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Center)
      .height('100%')

      this.collapseOrExpand();
    }
    .width('100%')
    .height(56)
    .margin({ bottom: $r('sys.float.padding_level3') })
    .padding({
      start: LengthMetrics.vp(10),
      end: LengthMetrics.vp(24)
    })
  }

  @Builder
  collapseOrExpand() {
    Row() {
      Button({ type: ButtonType.Capsule, stateEffect: true }) {
        Row() {
          Text(this.isCollapse ? $r('app.string.calendar_expand') : $r('app.string.calendar_collapse'))
            .draggable(false)
            .fontSize($r('sys.float.ohos_id_text_size_button3'))
            .fontFamily('sans-serif-condensed')
            .focusable(false)
            .fontColor(this.colorModeViewData.wifiOffTextColor)
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontWeight(FontWeight.Medium)
          SymbolGlyph(this.getSymbolGlyph())
            .fontSize($r('sys.float.ohos_id_text_size_headline8'))
            .fontColor([this.colorModeViewData.wifiOffTextColor])
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontWeight(FontWeight.Medium)
        }
        .padding({
          start: LengthMetrics.vp(8),
          end: LengthMetrics.vp(2)
        })
      }
      .onClick(this.throttle(() => {
        animateTo({
          duration: 200,
          curve: curves.interpolatingSpring(0, 1, 300, 29)
        }, () => {
          this.isCollapse = !this.isCollapse;
          this.monthViewModel.finishWeekUpdateByButton(this.isCollapse);
          this.updateHeight();
        });
      }, this.DELAY))
      .backgroundColor($r('app.color.ntf_pc_extra_button_color'))
      .borderRadius(14)
      .height(24)
      .stateStyles({
        normal: {
          .backgroundColor($r('app.color.ntf_pc_extra_button_color'))
          .border({ width: 0 })
        },
        pressed: {
          .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
          .border({ width: 0 })
        }
      })
    }
    .alignSelf(ItemAlign.Center)
    .height('100%')
  }

  @Builder
  dateAndSetting() {
    Row() {
      Row() {
        Text($r('app.string.date_time_settings'))
          .draggable(false)
          .id(COMPONENT_ID_TEXT_SETTING)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .focusable(true)
          .lineHeight(24)
          .fontColor(this.colorModeViewData.wifiOffTextColor)
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
      }
      .padding({
        left: $r('sys.float.padding_level10'),
        right: $r('sys.float.padding_level10'),
      })
      .onClick(() => {
        this.hidePanel(); // 收起面板
        StartAbilityUtil.startAbilityFromOther({
          bundleName: ExtAppConstants.PKG_SETTINGS,
          abilityName: ExtAppConstants.ABILITY_SETTINGS_MAIN,
          moduleName: DeviceHelper.is2In1DevicePcType() ? 'phone_settings' : 'pc_settings',
          uri: 'date_and_time'
        });
        // 打点
        ReportUtil.reportBehaviorEvent(ReportUtil.clickCalendarToSetting);
      })
      .height(40)
      .width('100%')
      .borderRadius($r('sys.float.corner_radius_level6'))
      .hoverEffect(HoverEffect.Highlight)
      .stateStyles({
        normal: {
          .border({ width: '2vp', color: '#00000000', })
          .backgroundColor(Color.Transparent)
        },
        focused: {
          .border({ width: '2vp', color: $r('sys.color.interactive_focus'), })
          .backgroundColor(this.dateAndTimerHover ? $r('sys.color.interactive_hover') : this.textColor)
        },
        pressed: {
          .border({ width: '2vp', color: '#00000000', })
          .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
        }
      })
      .onHover((isHover: boolean) => {
        this.dateAndTimerHover = isHover;
      })
    }
    .padding({ left: this.dateSettingMargin, right: this.dateSettingMargin })
    .margin({ top: $r('sys.float.padding_level2'), bottom: this.dateSettingMargin })
    .height(40)
    .width('100%')
  }

  build() {
    if (this.isAssemblyPanelShow) {
      Column() {
        this.dateTitle()

        SwiperMonthlyView({
          viewModel: this.monthViewModel
        })
        if (!this.isCollapse) {
          Divider()
            .margin({ left: 24, right: 24 })
            .color($r('sys.color.ohos_id_color_list_separator'))

          this.dateAndSetting()
        }
      }
      .id(COMPONENT_ID_CALENDAR)
      .margin(1)
      .justifyContent(FlexAlign.End)
    }
  }

  aboutToAppear() {
    this.is24HourFormat = this.get24HourFormat();
    this.monthViewModel.reInitByMonth(new Date(), this.isCollapse);
    this.monthViewModel.finishWeekUpdateByButton(this.isCollapse);
    this.subscribeEvent();
  }

  aboutToDisappear() {
    this.unsubscribeEvent();
  }

  getSymbolGlyph(): Resource | undefined {
    return !this.isCollapse ? $r('sys.symbol.chevron_down') : $r('sys.symbol.chevron_up');
  }

  hidePanel(): void {
    log.showInfo('Click then hidePanel!');
    windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL);
  }

  /**
   * 格式化时间信息
   *
   * @param displayYear 显示年份
   * @param displayMonth 显示月份
   */
  formatDate(displayYear: number, displayMonth: number) {
    const date = new Date(displayYear, displayMonth - 1);
    const locale = new intl.Locale(i18n.System.getSystemLanguage());
    const dateFormat = new intl.DateTimeFormat(locale.toString(), {
      year: 'numeric',
      month: 'short'
    });
    const dateStr: string = dateFormat.format(date);
    // 存在内存泄漏，需要手动释放
    // MemoryUtils.removeNapiWrap(dateFormat, false);
    return dateStr;
  }

  // 时间更新刷新当前天
  refreshCurrentDate() {
    this.monthViewModel.refreshCurrentDate();
  }

  // 重新打开状态栏日历将选中天更新到当天
  refreshDate() {
    this.monthViewModel.refreshDate();
  }

  /**
   * 防抖
   *
   * @param func 要限制调用的方法
   * @param delay 防抖间隔时间，默认300ms
   */
  debounce(tag: string, func: Function, delay: number = 300) {
    if (this.runningMap.get(tag)) {
      clearTimeout(this.runningMap.get(tag));
      this.runningMap.remove(tag);
    }
    ;
    const timerId = setTimeout((): void => {
      clearTimeout(this.runningMap.get(tag));
      this.runningMap.remove(tag);
      func();
    }, delay);
    this.runningMap.set(tag, timerId);
  }

  /**
   * 限流器，用于防快速点击
   *
   * @param func
   * @param delay = 300
   */
  throttle(func: () => void, delay = 300): () => void {
    let timer: number | null = null;
    return () => {
      const context = this;
      const args = arguments;
      if (!timer) {
        func();
        timer = setTimeout(() => {
          clearTimeout(timer);
          timer = null;
        }, delay);
      }
    }
  }

  /**
   * 跳转到下个月1号
   *
   * @param directionState 切换方向 即下一个月或上一个月
   * @param method 方法选择 即通过箭头切换还是点击月视图切换
   */
  jumpMonth(directionState: number) {
    let status: string;

    switch (directionState) {
      case UpdateState.NEXT_MONTH_STATE:
        this.monthViewModel.swiperController.showNext();
        status = 'next';
        break;
      case UpdateState.PRE_MONTH_STATE:
        this.monthViewModel.swiperController.showPrevious();
        status = 'previous';
        break;
      default:
        log.showError(`Invalid directionState: ${directionState}`);
        return;
    }

    // 打点
    const params: ReportHiEventParams = {
      STATUS: status
    };
    ReportUtil.reportBehaviorEvent(ReportUtil.clickCalendarPanelArrow, params);
  }

  get24HourFormat(): boolean {
    return i18n.System.is24HourClock();
  }

  /**
   * 订阅用户设置系统时间、时区事件、日期时间
   */
  private subscribeEvent(): void {
    try {
      commonEventManager.createSubscriber({
        events: [
          commonEventManager.Support.COMMON_EVENT_TIME_CHANGED,
          commonEventManager.Support.COMMON_EVENT_TIMEZONE_CHANGED,
          commonEventManager.Support.COMMON_EVENT_TIME_TICK,
        ]
      }).then((subscriber: commonEventManager.CommonEventSubscriber) => {
        log.showInfo('createSubscriber succeed');
        this.subscriber = subscriber;
        commonEventManager.subscribe(this.subscriber, () => {
          log.showInfo('dateChangeEventHandler');
          this.dateChangeEventHandler();
        });
      }).catch((error: BusinessError) => {
        log.showError(`createSubscriber error, code: ${error.code}, message: ${error.message}`);
      });
    } catch (error) {
      log.showError(`CommonEventManager failed, code: ${error.code}, message: ${error.message}`);
    }
  }

  public dateChangeEventHandler(): void {
    this.debounce('dateChangeEventHandler', () => {
      this.refreshCurrentDate();
    }, this.DELAY);
  }

  /**
   * 销毁公共事件订阅
   */
  private unsubscribeEvent(): void {
    try {
      if (this.subscriber) {
        commonEventManager.unsubscribe(this.subscriber, (err) => {
          if (err) {
            log.showError(`unsubscribe fail ,error is ${err.message} `);
            this.subscriber = null;
            return;
          }
          this.subscriber = null;
        });
      }
    } catch (error) {
      log.showError(`release callback failed, code: ${error.code}, message: ${error.message}`);
    }
  }
}
