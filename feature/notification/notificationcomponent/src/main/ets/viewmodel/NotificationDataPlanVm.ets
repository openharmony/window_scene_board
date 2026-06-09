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
import { LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper, obtainStartAbilityWithWant, TargetPanel } from '@ohos/frameworkwrapper';
import { EventManagerAdapter, NotificationSysEventReporter } from '@ohos/systemuicommon';
import { SystemUICommonUtil } from '@ohos/systemuicommon';
import {
  CellularDataVm,
  DeviceInfoVm,
  DropdownVm,
  INotificationDataPlanVm,
  INotificationHeaderVm,
  NotificationBaseVm,
} from '@ohos/systemuicommon/newIndex';
import { DataInfo, NtfDisplayDataInfo } from '@ohos/systemuicommon/src/main/ets/vm/CellularDataVm';
import { NotificationDataPlanAnimation } from '../animation/NotificationDataPlanAnimation';
import { ResUtils } from '@ohos/windowscene';
import { MeasureText, Size } from '@kit.ArkUI';
import { ArkUIAdapter, ViewName } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { i18n } from '@kit.LocalizationKit';

const TAG = 'NotificationDataPlanVm';
const log = Logger.getLogHelper(LogDomain.NC);

@ObservedV2
export class NotificationDataPlanVm extends NotificationBaseVm implements INotificationDataPlanVm {
  /**
   * 流量文本
   */
  @Trace public todayUseDataText: string = ResUtils.getInnerStringNumS($r('app.string.data_use_today'), '-- KB');
  @Trace public totalDataText: string = ResUtils.getInnerStringNumS($r('app.string.data_total'), '-- KB');
  @Trace public remainDataText: string = ResUtils.getInnerStringNumS($r('app.string.data_remain'), '-- KB');
  /**
   * 是否接入天水计划
   */
  @Trace public isTianShuiConnected: boolean = false;
  /**
   * 水平对齐规格
   */
  @Trace public flexAlign: FlexAlign = this.isTianShuiConnected ? FlexAlign.End : FlexAlign.Start;

  /**
   * 下拉跟手动效
   */
  @Trace public followAnim?: AnimateParam;

  /**
   * 流量文本缩放
   */
  @Trace public dataTextScale = 1

  /**
   * 流量文本透明度
   */
  @Trace public dataTextOpacity = 0

  /**
   * 流量文本位移
   */
  @Trace public dataTextTranslateY = 0

  /**
   * 流量文本字体大小
   */
  @Trace public dataTextFontSize: Resource = this.getDataTextFontSize();
  /**
   * 流量文本字重
   */
  @Trace public dataTextFontWeight: FontWeight = FontWeight.Normal;
  /**
   * 流量文本行高
   */
  @Trace public dataTextLineHeight: Resource | undefined = undefined;
  /**
   * 数据加载完成标识
   */
  @Trace private loadSuccess: boolean = false;
  @Trace private todayData: number = 0;
  @Trace private totalData: number = 0;
  @Trace private remainData: number = 0;
  /**
   * 无障碍播报文本
   */
  @Trace public accessibilityText: string = ResUtils.getInnerString($r('app.string.text_loading'));
  /**
   * 延迟加载
   */
  @Trace public delayLoad: boolean = false;

  /**
   * 剩余流量文本宽度
   */
  @Trace public remainTextWidth?: Length;

  private preDataTransY: number = 0;
  /**
   * 前一次下拉面板距离
   */
  public preDropDownMoveY: number = 0;

  @Computed
  get headerVm(): INotificationHeaderVm {
    return this.vmInjector.getHeaderVm()!;
  }

  init(): void {
    CellularDataVm.instance.registerDataPlanRefreshCallback(this.refreshDisplayDataInfo);
  }

  destroy(): void {
    CellularDataVm.instance.unRegisterDataPlanRefreshCallback(this.refreshDisplayDataInfo);
  }

  @Trace public canDisplayAll: boolean = true;

  getId(text: string): string {
    return this.vmInjector.getId(TAG + '_' + text);
  }

  public refreshDisplayDataInfo = (dataPlan: NtfDisplayDataInfo): void => {
    try {
      log.showInfo(TAG, `refreshDisplayDataInfo`);
      this.loadSuccess = true;
      const today = dataPlan.todayUseData;
      if (today) {
        this.todayData = today.data;
        this.todayUseDataText = ResUtils.getInnerStringNumS($r('app.string.data_use_today'), this.getI18nUnit(today));
      }

      const total = dataPlan.totalData;
      if (total) {
        this.totalData = total.data;
        this.totalDataText = ResUtils.getInnerStringNumS($r('app.string.data_total'), this.getI18nUnit(total));
      }

      const month = dataPlan.monthlyRemainData;
      if (month) {
        this.remainData = month.data;
        this.remainDataText =
          ResUtils.getInnerStringNumS(month.data < 0 ? $r('app.string.data_exceed') : $r('app.string.data_remain'),
            this.getI18nUnit(month));
      }

      if (DropdownVm.instance.isShow) {
        this.delayLoad = true;
        this.vmInjector.getListScrollerVm()?.scroller.scrollEdge(Edge.Top, { velocity: 100 });
        const height = ResUtils.getNumber($r('app.float.ntf_data_plan_margin_top')) +
        ResUtils.getNumber(this.getDataTextFontSize());
        setTimeout(() => {
          this.delayLoad = false;
        }, height / 100 * 1000 + 50);
      }
    } catch (e) {
      log.showWarn(TAG, `refreshDataPlanInfo error. ${e}`);
    }
  }

  private getI18nUnit(dataInfo: DataInfo): string {
    const local = i18n.System.getSystemLocale();
    const unitMap: Map<string, string> = new Map([
      ['KB', 'kilobyte'],
      ['MB', 'megabyte'],
      ['GB', 'gigabyte'],
      ['TB', 'terabyte']
    ])
    const ntf = new Intl.NumberFormat(local,
      { style: 'unit', unit: `${unitMap.get(dataInfo.unit) ?? 'kilobyte'}`, unitDisplay: 'short' });
    return ntf.format(Math.abs(dataInfo.data)).toUpperCase();
  }

  @Monitor('todayUseDataText', 'totalDataText', 'remainDataText')
  onDataTextChange(): void {
    const todayWidth = this.getTextWidth(this.todayUseDataText);
    const totalWidth = this.getTextWidth(this.totalDataText);
    const symbolWidth = this.remainData < 0 ? 19 : 0;
    const remainWidth = this.getTextWidth(this.remainDataText);
    let spaceWidth = 2 * this.getTextWidth(' | ');
    const dataViewWidth = this.vmInjector.getPanelVm().cardWidth -
      2 * ResUtils.getNumber($r('app.float.ntf_item_padding_start_end'));

    this.canDisplayAll = todayWidth + totalWidth + symbolWidth + remainWidth + spaceWidth <= dataViewWidth;
    if (this.canDisplayAll) {
      this.accessibilityText = this.todayUseDataText + ' | ' + this.totalDataText  + ' | ' + this.remainDataText;
    } else {
      this.accessibilityText = this.todayUseDataText + ' | '  + this.remainDataText;
      spaceWidth = spaceWidth / 2;
      const availableWidth = dataViewWidth - todayWidth - symbolWidth - spaceWidth ;
      log.showInfo(TAG, `availableWidth: ${availableWidth}`)
      if (availableWidth < remainWidth) {
        this.remainTextWidth = availableWidth;
      }
    }
    log.showInfo(TAG,
      `dataViewWidth: ${dataViewWidth}, todayWidth: ${todayWidth}, totalWidth: ${totalWidth}, symbolWidth: ${symbolWidth}, remainWidth: ${remainWidth}, canDisplayAll: ${this.canDisplayAll}`)
  }

  private getTextWidth(text: string): number {
    const size = MeasureText.measureTextSize({
      textContent: text,
      maxLines: 1,
      overflow: TextOverflow.Ellipsis,
      fontWeight: this.dataTextFontWeight,
      fontSize: this.dataTextFontSize,
      lineHeight: this.dataTextLineHeight,
    });
    return ArkUIAdapter.px2vp(size.width as number);
  }

  public getTextHeight(): number {
    const text = this.todayUseDataText
    const size = MeasureText.measureTextSize({
      textContent: text,
      maxLines: 1,
      overflow: TextOverflow.Ellipsis,
      fontWeight: this.dataTextFontWeight,
      fontSize: this.dataTextFontSize,
      lineHeight: this.dataTextLineHeight,
    });
    return ArkUIAdapter.px2vp(size.height as number);
  }

  @Computed
  get isShowDataPlan(): boolean {
    return CellularDataVm.instance.isShowData;
  }

  dataExceed(): boolean {
    log.showInfo(TAG, `loadSuccess: ${this.loadSuccess}, remainData: ${this.remainData}`)
    return this.loadSuccess && this.remainData < 0;
  }

  reset(): void {
    this.loadSuccess = false;
    this.accessibilityText = ResUtils.getInnerString($r('app.string.text_loading'));
    this.todayUseDataText = ResUtils.getInnerStringNumS($r('app.string.data_use_today'), '-- KB');
    this.totalDataText = ResUtils.getInnerStringNumS($r('app.string.data_total'), '-- KB');
    this.remainDataText = ResUtils.getInnerStringNumS($r('app.string.data_remain'), '-- KB');
    this.remainTextWidth = undefined;
  }

  getDataTextFontSize(): Resource {
    return DeviceHelper.isPad() ? $r('app.float.ntf_title_pad_data_font_size') :
    $r('app.float.ntf_title_data_font_size');
  }

  /**
   * 跳转到流量数据
   */
  jumpToDataPage(): void {
    EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
      bundleName: 'com.ohos.settings',
      abilityName: 'com.ohos.settings.MainAbility',
      uri: 'mobile_data_manage_entry',
      moduleName: 'phone_settings'
    }));

    NotificationSysEventReporter.notificationPanelDataPlan({
      TIME_STAMP: `${DropdownVm.instance.lastDropdownTime}`
    });
  }

  /**
   * 横屏动效跟随
   */
  dataPlanDoFollowHandAnim(firstCardTransY: number): void {
    // 执行缩放动效的时候，组件不跟随移动，动效设为undefined
    this.followAnim = undefined;
    const dataTranY =
      ResUtils.getNumber($r('app.float.ntf_title_padding_bottom')) + ResUtils.getNumber(this.dataTextFontSize) / 2;
    if (firstCardTransY < 0) {
      this.dataTextScale = Math.max(0.4, 1 + (0.8 / dataTranY * firstCardTransY));
      this.dataTextOpacity = Math.max(0, 1 + (1 / dataTranY * firstCardTransY));
    } else {
      this.dataTextScale = 1;
      this.dataTextOpacity = 1;
    }
  }

  /**
   * 横屏动效回弹
   */
  dataPlanDoFollowUpdateTransY(transY: number, dropDownMoveY: number): void {
    if (this.preDataTransY === transY) {
      return;
    }
    if ((dropDownMoveY === 0 && this.preDropDownMoveY === 0) || this.preDropDownMoveY < 0) {
      this.followAnim = undefined
    } else {
      this.followAnim = { duration: 500, curve: Curve.Friction, }
    }
    this.dataTextTranslateY = transY;
    this.preDataTransY = transY;
    this.preDropDownMoveY = dropDownMoveY;
  }

  showDataText(): void {
    this.dataTextOpacity = 1;
    this.dataTextScale = NotificationDataPlanAnimation.dataShowScale;
    this.dataTextTranslateY = 0;
  }

  doDataAnim(isShow: boolean): void {
    // 动效管理
    const dataPlanAnimation: NotificationDataPlanAnimation = new NotificationDataPlanAnimation();
    if (isShow) {
      dataPlanAnimation.doShowAnim(this);
    } else if (DropdownVm.instance.dropdownEvent.target === TargetPanel.NOTIFICATION_PANEL) {
      dataPlanAnimation.doHideAnim(this);
    }
  }
}