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
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { NtfSearchController, ResultItemInfo, ResultItemInfoTask } from '../common/NtfSearchController';
import {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import { sSettingsUtil } from '@ohos/managementcomponent';
import { SettingsKeyConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { fontScaleManager, FontScaleState } from '@ohos/managementcomponent';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import {
  NotificationConfigEvent,
  NotificationConfigEventType
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { NotificationConfigEntity } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { LengthMetrics } from '@ohos.arkui.node';
import uiAppearance from '@ohos.uiAppearance';
import { DeviceHelper } from '@ohos/managementcomponent';
import { NtfSearchResultView } from './NtfSearchResultView';
import { StatusBarModel } from '../model/StatusBarModel';
import { AppItem } from '@ohos/managementcomponent/src/main/ets/com/ohos/vm/appLstComponentViewModel';
import { Pinyin } from '@ohos/frameworkpinyin/src/main/ets/utils/Pinyin';
import curves from '@ohos.curves';
import { AccessibilityManager } from '../common/AccessibilityManager';

const TAG = 'NtfSearchPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
/* 2 表示BMS， 1 表示桌面 */
const SEARCH_SOURCE_CHANNEL = '2';

@Entry
@Component
export struct NtfSearchPage {
  searchController: NtfSearchController = new NtfSearchController();
  @State historyMap: Map<string, number> = new Map();
  private appMapping: Map<string, NotificationConfigEntity> = new Map();
  @State searchResultList: ResultItemInfo[] = [];
  @State isSearchProcessed: boolean = false;
  @State historyList: string[] = [];
  @State searchValue: string = '';
  @Consume('pageInfos') pageInfos: NavPathStack;
  @StorageLink('titleBarMargin')
  @Watch('onTitleBarMarginChanged') titleBarMargin: number = 0;
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  @State statusBarModel: StatusBarModel = StatusBarModel.get();
  @State pcBackButtonColor: Resource | Color = Color.Transparent;
  @State backButtonRadius: Resource = $r('app.float.enable_component_image_radius');
  @State transY: number = 56;
  private backMargin: LocalizedMargin = {};

  private historyListInit(): void {
    let historyStr: string = sSettingsUtil.getSecureValue(SettingsKeyConstants.NTF_SEARCH_HISTORY_LIST, '') ?? '';
    if (historyStr !== '') {
      this.historyList = historyStr.split(',');
    }
    this.historyList.forEach((item) => {
      this.historyMap.set(item, Date.now());
    });
  }

  onTitleBarMarginChanged() {
    log.showInfo(`titleBar margin changed： ${this.titleBarMargin}`);
  }

  private historyListSave(): void {
    let historyStr: string = '';
    for (let idx = 0; idx < this.historyList.length; ++idx) {
      historyStr += this.historyList[idx];
      if (idx != this.historyList.length - 1) {
        historyStr += ',';
      }
    }
    sSettingsUtil.setSecureValue(SettingsKeyConstants.NTF_SEARCH_HISTORY_LIST, historyStr);
    this.historyMap.clear();
  }

  aboutToAppear(): void {
    log.showInfo('AboutToAppear');
    this.historyListInit();
    this.initBackIconMargin();
    notificationSettingManager.subscribeChangeEvent(this.onNtfConfigChange);
  }

  private initBackIconMargin = () => {
    this.backMargin = {
      start: DeviceHelper.isPC() ? LengthMetrics.resource($r('app.float.pc_back_button_margin_l')) :
        LengthMetrics.resource($r('app.float.page_margin_l')),
      top: LengthMetrics.resource($r('app.float.head_component_title_margin_top'))
    };
  }
  private fusionSearchAdmissionStateChange = (isEnable: boolean): void => {
    log.showInfo('FusionSearchAdmissionStateChange, isEnable: %{public}s', isEnable);
    if (isEnable) {
      this.executeSearch(this.searchValue);
    }
  }

  aboutToDisappear(): void {
    log.showInfo('AboutToDisappear');
    this.historyListSave();
    notificationSettingManager.unsubscribeChangeEvent(this.onNtfConfigChange);
  }

  private onNtfConfigChange = (event: NotificationConfigEvent): void => {
    if (event.type === NotificationConfigEventType.ADD_ITEM ||
      event.type === NotificationConfigEventType.DELETE_ITEM) {
      this.inputSearchValue(this.searchValue, true);
    }
  };

  build() {
    NavDestination() {
      this.buildTitleComponent()
      this.buildResultCard()
    }
    .transition(TransitionEffect.OPACITY)
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.ohos_id_color_titlebar_sub_bg'))
    .padding({ top: this.statusBarModel.height })
    .onBackPressed(this.onBackPressed)
    .onShown(this.doPageAnimation)
    .onHidden(this.doPageHidden);
  }

  private doPageAnimation = (): void => {
    log.showInfo('DoPageAnimation.');
    this.getUIContext().animateTo({
      curve: curves.interpolatingSpring(0, 1, 342, 38),
    }, () => {
      this.transY = 0;
    });
    this.searchController.init();
  }
  private doPageHidden = () => {
    log.showInfo('DoPageHidden.');
  }
  private onBackPressed = (): boolean => {
    this.navBackBtnEvent();
    return true;
  }
  onInputFocus = () => {

  }

  /**
   * 这个页面下包含search组件, Flex组件在内的多个组件不能使用maxFontScale属性适配适老化, 这里使用手动获取缩放倍数的临时方案.
   * 支持完善后可以删除该方法
   * @param size
   * @returns
   */
  private getScaledSize(size: number): Length {
    const curScale = uiAppearance.getFontScale();
    log.showInfo(`cur system font scale:${curScale}`);
    return Math.min(curScale, 2) * size + 'vp';
  }

  @Styles
  normalStyles() {
    .backgroundColor(DeviceHelper.isPC() ? this.pcBackButtonColor : $r('sys.color.ohos_id_color_button_normal'))
    .borderRadius(DeviceHelper.isPC() ? this.backButtonRadius : $r('app.float.nav_back_image_bg_radius'))
  }

  @Styles
  pressedStyles() {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
    .borderRadius(DeviceHelper.isPC() ? $r('app.float.enable_component_image_radius') :
      $r('app.float.nav_back_image_bg_radius'))
  }

  private navBackBtnEvent = () => {
    this.getUIContext().animateTo({
      // 返回主页动效曲线
      curve: curves.interpolatingSpring(0, 1, 342, 38)
    }, () => {
      this.transY = 56;
      this.pageInfos.pop(false);
    })
  }

  @Builder
  buildNavBackButton() {
    Stack({ alignContent: Alignment.Center }) {
      SymbolGlyph($r('sys.symbol.chevron_backward'))
        .width($r('app.float.appitem_header_icon_width'))
        .height($r('app.float.appitem_header_icon_height'))
        .draggable(false)
        .fontColor([$r('sys.color.ohos_fa_icon_primary')])
        .fontSize($r('app.float.appitem_header_icon_height'))
    }
    .id(TAG + '_backButton')
    .transition(TransitionEffect.OPACITY.combine(TransitionEffect.translate({ y: 56 })))
    .width($r('app.float.nav_back_image_bg_width_height'))
    .height($r('app.float.nav_back_image_bg_width_height'))
    .onClick(this.navBackBtnEvent)
    .stateStyles({
      normal: this.normalStyles,
      pressed: this.pressedStyles,
    })
    .onHover((isHover: boolean) => {
      if (!DeviceHelper.isPC()) {
        return;
      }
      this.pcBackButtonColor = isHover ? $r('sys.color.ohos_id_color_button_normal') : Color.Transparent;
      this.backButtonRadius = isHover ? DeviceHelper.isPC() ? $r('app.float.enable_component_image_radius') :
        $r('sys.float.ohos_id_corner_radius_clicked') : $r('app.float.nav_back_image_bg_radius');
    })
    .margin(this.backMargin)
    .align(Alignment.Center)
    .accessibilityText(getContext(this)?.resourceManager.getStringSync($r('app.string.psd_back_accessible').id))
  }

  @Builder
  buildTitleComponent() {
    Row() {
      this.buildNavBackButton()
      this.buildSearchComponent()
    }
    .margin({ top: -30, left: 4 })
    .alignSelf(ItemAlign.Start)
  }

  @Builder
  buildSearchComponent() {
    Search({
      value: this.searchValue,
      placeholder: $r('app.string.search_app'),
      controller: new SearchController()
    })
      .id(TAG + '_searchComponent')
      .layoutWeight(1)
      .enablePreviewText(false)
      .margin({
        start: LengthMetrics.vp(8),
        end: this.titleBarMargin === 0 ? LengthMetrics.resource($r('app.float.search_bar_nav_margin')) :
          LengthMetrics.vp(this.titleBarMargin)
      })
      .geometryTransition('SEARCH_ONE_SHOT_TRANSITION_ID', { follow: true })
      .textFont({
        size: this.getScaledSize(14),
      })
      .placeholderFont({
        size: this.getScaledSize(14),
      })
      .height($r('app.float.appitem_notice_info_icon_width'))
      .backgroundColor($r('sys.color.ohos_id_color_text_field_sub_bg'))
      .defaultFocus(true)
      .onFocus(this.onInputFocus)
      .onSubmit((value: string) => {
        this.searchValue = value;
        if (value.trim().length === 0) {
          return;
        }
        // 提交搜索内容
        this.inputSearchValue(value, false, true);
      })
      .onChange((value: string) => {
        this.searchValue = value;
        if (value.trim().length === 0) {
          this.isSearchProcessed = false;
          this.searchResultList = [];
          return;
        }
        // 搜索框文本变动，也会提交搜索内容
        this.inputSearchValue(value);
      })
  }

  private async inputSearchValue(value: string, needUpdateAppList: boolean = false,
    display: boolean = false): Promise<void> {
    console.log(`zxzcdddcdmcmmcmcm inputSearchValue`)
    NtfSettingSysEventReporter.notificationSearchApp({
      KEY_WORD: value
    });
    if (display == true) {
      if (!this.historyMap?.has(this.searchValue)) {
        this.historyList.push(this.searchValue);
      }
      this.historyMap.set(this.searchValue, Date.now());
      this.historyList.sort((a, b) => {
        return (this.historyMap.get(b) ?? 0) - (this.historyMap.get(a) ?? 0);
      });
    }
    if (!this.appMapping.size || needUpdateAppList) {
      this.appMapping.clear();
      (await notificationSettingManager.getAppList())
        .filter(it => !it.settingIgnore)
        .forEach(it => this.appMapping.set(it.bundle, it));
    }

    this.executeSearch(value);
  }

  private executeSearch(value: string) {
    log.showInfo('executeSearch for %{public}s', value);
    this.searchController.inputChangeEvent(value, SEARCH_SOURCE_CHANNEL).then((resultInfo: ResultItemInfoTask) => {
      this.logSearchResult(resultInfo);
      // 快速输入的情况下，接口返回时序有问题，对比this.searchValue与resultList对应的搜索值，不同说明不是最新一次的输入，无需更新list
      if (this.searchValue !== resultInfo.searchKey) {
        log.showWarn('Latest searchValue [%{public}d] searchKey [%{public}s]', this.searchValue, resultInfo.searchKey);
        return;
      }
      if (this.searchValue.trim().length === 0) {
        log.showWarn(`search value size is zero, no need display result`);
        this.isSearchProcessed = false;
        this.searchResultList = [];
        return;
      }

      this.searchResultList = this.uniqueBy(resultInfo.resultList ?? [], (item) => {
        return `${item.bundleName}_${item.appIndex ?? 0}`;
      }).filter(item => {
        return (item.appName?.split('.').length <= 1) && this.appMapping.has(item.bundleName);
      }).map(it => {
        it.appName = this.appNameDeal(it.appName);
        return it;
      });

      log.showInfo(`search result list size is ${this.searchResultList.length}`);
      this.isSearchProcessed = true;
    });
  }

  private uniqueBy<T>(array: T[], keyGenerator: (item: T) => string): T[] {
    const ret: T[] = [];
    const uniqueKeySet: Set<string> = new Set();
    for (const item of array) {
      const itemKey = keyGenerator(item);
      if (uniqueKeySet.has(itemKey)) {
        log.showWarn('Exists same item by %{public}s', itemKey);
      } else {
        ret.push(item);
        uniqueKeySet.add(itemKey);
      }
    }
    return ret;
  }

  private logSearchResult(resultInfo: ResultItemInfoTask): void {
    if (resultInfo.resultList?.length === 0) {
      log.showWarn('Origin search for %{public}s return empty', resultInfo.searchKey);
    } else {
      resultInfo.resultList.forEach(it => {
        log.showInfo('Origin search for %{public}s, ret: %{public}s, %{public}s, %{public}d',
          resultInfo.searchKey, it.appName, it.sourceChannel, it.appIndex);
      });
    }
  }

  private appNameDeal(appName: string): string {
    if (!appName) {
      return appName;
    }
    let result = appName;
    let replaceStrArray: string[] = ['<em>', '</em>'];
    for (let replaceStr of replaceStrArray) {
      result = result.replaceAll(replaceStr, '');
    }
    return result;
  }

  @Builder
  buildResultCard() {
    if (this.isSearchProcessed) {
      // 如果已经做了搜索操作，显示搜索结果或显示“没有搜索结果”图标
      NtfSearchResultView({
        searchResultList: this.searchResultList,
        appMapping: this.appMapping,
        historyList: this.historyList,
        historyMap: this.historyMap,
        searchValue: this.searchValue
      })
    } else if (this.historyList.length !== 0) {
      // 没有做搜索操作且历史记录不为空
      this.buildHistoryTitle();
      this.buildHistoryList();
    }
  }

  @Builder
  buildHistoryTitle() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
      Text($r('app.string.search_history'))
        .fontSize(this.getScaledSize(18))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
        .fontWeight(FontWeight.Bold)
      Button() {
        Image($r('app.media.trash'))
          .width($r('app.float.appitem_notice_infopop_icon_width'))
          .height($r('app.float.appitem_notice_infopop_icon_height'))
          .fillColor($r('sys.color.ohos_id_color_text_primary'))
          .draggable(false)
      }
      .accessibilityText(getContext(this)?.resourceManager.getStringSync($r('app.string.clear')))
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        this.historyList = [];
        this.historyMap.clear();
        NtfSettingSysEventReporter.notificationClearSearchHistory();
        AccessibilityManager.getInstance()?.sendAccessibility(getContext(this)?.resourceManager.getStringSync($r('app.string.already_clear')));
        AccessibilityManager.getInstance()?.requestFocusAccessibility(TAG + '_backButton');
      })
    }
    .translate({ y: this.transY })
    .constraintSize({ minHeight: $r('app.float.itemComp_image_height') })
    .margin({
      top: $r('app.float.page_status_bar_setting_margin_t'),
      left: $r('app.float.appitem_icon_margin_r'),
      right: $r('app.float.appitem_icon_margin_r')
    })
  }

  @Builder
  buildHistoryList() {
    Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, alignContent: FlexAlign.Start }) {
      ForEach(this.historyList, (value: string) => {
        Text(value)
          .fontSize(this.getScaledSize(12))
          .constraintSize({ minHeight: $r('app.float.search_history_font_size') })
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .constraintSize({ minWidth: $r('app.float.search_image_scale') })
          .textAlign(TextAlign.Center)
          .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
          .margin({
            top: LengthMetrics.resource($r('app.float.itemComp_padding_r')),
            end: LengthMetrics.resource($r('app.float.itemComp_padding_r'))
          })
          .padding({
            top: $r('app.float.status_bar_switchComp_padding_r'),
            right: $r('app.float.itemComp_padding_r'),
            bottom: $r('app.float.status_bar_switchComp_padding_r'),
            left: $r('app.float.itemComp_padding_r')
          })
          .borderRadius($r('app.float.switchComp_height'))
          .onClick(() => {
            this.searchValue = '';
            this.searchValue = value;
            AccessibilityManager.getInstance()?.requestFocusAccessibility(TAG + '_searchComponent');
          })
      })
    }
    .translate({ y: this.transY })
    .margin({
      left: $r('app.float.appitem_icon_margin_r'),
      right: $r('app.float.appitem_icon_margin_r')
    })
  }
}
