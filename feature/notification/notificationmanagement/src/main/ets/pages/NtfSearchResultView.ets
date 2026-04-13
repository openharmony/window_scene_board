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

import { ResultItemInfo } from '../common/NtfSearchController';
import { NotificationConfigEntity } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import uiAppearance from '@ohos.uiAppearance';
import { LengthMetrics } from '@kit.ArkUI';
import {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import { AppIconWithIndexSubIcon } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import BundleResourceModel from '@ohos/managementcomponent/src/main/ets/com/ohos/model/bundleResourceModel';
import { KeyValPair } from '@ohos/managementcomponent/src/main/ets/com/ohos/model/SystemUISettingSession';
import { PageConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { NtfSettingRtlUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingRtlUtil';
import { NtfSettingJumpEvent as JumpEvt, SettingRouterParam } from '@ohos/managementcomponent/src/main/ets/com/ohos/event/NtfSettingEvent';
import { EvtBus } from '@ohos/managementcomponent';

const TAG = 'NtfSearchResultView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const SEARCH_RESULT_BADGE_ICON_SIZE: number = 32;
const DEFAULT_BADGE_ICON_SIZE: number = 54;

@Component
export struct NtfSearchResultView {
  scroller: Scroller = new Scroller;
  @Link historyMap: Map<string, number>;
  appMapping: Map<string, NotificationConfigEntity> = new Map();
  @Prop searchResultList: ResultItemInfo[] = [];
  @Link historyList: string[];
  @State hoverIdx: number = -1;
  @Consume('pageInfos') pageInfos: NavPathStack;
  @Prop searchValue: string = '';


  build() {
    Row() {
      this.buildResultCard();
    }
  }

  @Builder
  buildResultCard() {
    // 如果已经做了搜索操作，显示搜索结果或显示“没有搜索结果”图标
    if (this.searchResultList.length === 0) {
      this.buildEmptyResultComponent();
    } else {
      Stack({ alignContent: Alignment.TopEnd }) {
        this.buildResultListComponent()
        this.scrollBar();
      }
      .padding({
        top: $r('app.float.enableComp_font_size')
      })
      .backgroundColor(Color.Transparent)
      .layoutWeight(1)
    }
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

  @Builder
  buildEmptyResultComponent(): void {
    Column() {
      Image($r('app.media.search_no_result'))
        .width($r('app.float.search_result_empty_image_scale'))
        .height($r('app.float.search_result_empty_image_scale'))
        .margin({ bottom: $r('app.float.repeatDialog_cont_font') })
        .draggable(false)
      Text($r('app.string.no_matching_results'))
        .fontColor($r('sys.color.ohos_id_color_text_hint'))
        .fontSize($r('app.float.itemComp_value_font'))
        .maxFontScale(2)
    }.offset({ y: '130' })
    .margin({
      left: $r('app.float.appitem_icon_margin_r'),
      right: $r('app.float.appitem_icon_margin_r')
    })
  }

  @Builder
  buildResultListComponent() {
    Scroll(this.scroller) {
      // 查询结果列表
      this.buildResultListItems()
    }
    .id('searchResultListComponent')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .onScrollStart(() => {
      focusControl.requestFocus('searchResultListComponent')
    })
    .margin({
      left: $r('app.float.app_list_indexer_padding_left_right'),
      right: $r('app.float.app_list_indexer_padding_left_right'),
      bottom: $r('app.float.appitem_page_search_bottom')
    })
    .borderRadius($r('app.float.enable_radio_width'))
  }

  @Builder
  buildResultListItems() {
    Column() {
      if (this.searchResultList.length > 0) {
        this.buildFinallyList();
      }
      Row().height(ContextManager.aiBarHeightByVp);
    }.constraintSize({ minHeight: '100%' })
  }

  @Builder
  buildFinallyList() {
    List() {
      ForEach(this.searchResultList,
        (item: ResultItemInfo, index: number) => {
          this.buildResultListItem(item, index)
        })
    }
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .borderRadius($r('app.float.enable_radio_width'))
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding($r('app.float.hover_item_padding_or_margin'))
    .divider({
      strokeWidth: '1px',
      color: $r('sys.color.comp_divider'),
      startMargin: $r('app.float.search_list_divider_left_margin'),
      endMargin: $r('app.float.search_list_divider_right_margin')
    })
    .margin({ bottom: $r('app.float.applist_margin_t') })
    .onHover((isHover?: boolean) => {
      if (isHover === false) {
        this.hoverIdx = -1;
      }
    })
  }

  @Builder
  buildResultListItem(item: ResultItemInfo, index: number) {
    ListItem() {
      this.buildResultItem(item);
    }
    .width('100%')
    .padding({
      left: $r('app.float.ntf_search_list_padding'),
      right: $r('app.float.ntf_search_list_padding'),
    })
    .borderRadius($r('app.float.hovered_border_radius'))
    .onClick(() => {
      if (!this.historyMap?.has(this.searchValue)) {
        this.historyList.push(this.searchValue);
      }
      this.historyMap.set(this.searchValue, Date.now());
      this.historyList.sort((a, b) => {
        return (this.historyMap.get(b) ?? 0) - (this.historyMap.get(a) ?? 0);
      });
      log.showInfo(`search result item ${item.appName}-${item.appIndex} click, then jump to setEnable.`);
      NtfSettingSysEventReporter.notificationClickSearchResult({
        KEY_WORD: this.searchValue,
        SEARCH_RESULT: item.bundleName
      });

      this.jumpMgmtView(item);
    })
    .onHover((isHover?: boolean) => {
      if (isHover) {
        this.hoverIdx = index;
      }
    })
    .stateStyles({
      focused: {
        .backgroundColor($r('sys.color.ohos_id_color_hover'))
        .borderRadius($r('app.float.ntf_search_list_press_shadow_radius'))
      },
      pressed: {
        .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
        .borderRadius($r('app.float.ntf_search_list_press_shadow_radius'))
      },
      normal: {
        .backgroundColor(this.hoverIdx === index ?
        $r('sys.color.ohos_id_color_hover') : Color.Transparent)
      }
    })
  }

  @Builder
  buildResultItem(item: ResultItemInfo) {
    Row() {
      AppIconWithIndexSubIcon({
        appIcon: this.appMapping.get(item.bundleName)?.icon,
        appIconSize: LengthMetrics.resource($r('app.float.search_image_scale')).value,
        compMargin: { end: LengthMetrics.resource($r('app.float.ntf_search_icon_margin_right')) },
        subIconSize: '12vp',
        index: item.appIndex,
        needShowBadgeIcon: false,
      })
      Row() {
        Text(item.appName)
          .fontSize(this.getScaledSize(16))
          .lineHeight(this.getScaledSize(21))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontFamily('HarmonyHeiTi')
          .padding({ end: LengthMetrics.resource($r('app.float.page_notice_info_label_margin')) })
      }.layoutWeight(1)

      Image($r('app.media.ic_settings_arrow'))
        .width($r('app.float.itemComp_image_width'))
        .height($r('app.float.page_notice_part_margin_t'))
        .fillColor($r('sys.color.ohos_id_color_fourth'))
        .draggable(false)
        .rotate({ z: 1, angle: NtfSettingRtlUtil.getSystemRTL() ? 180 : 0 })
    }
    .constraintSize({
      minHeight: $r('app.float.ntf_search_app_item_height')
    })
    .width('100%')
  }

  @Builder
  scrollBar() {
    ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Vertical, state: BarState.Auto })
      .height('100%')
      .margin({ bottom: ContextManager.aiBarHeightByVp })
  }

  private jumpMgmtView(item: ResultItemInfo): void {
    let bundleResourceModule: BundleResourceModel = new BundleResourceModel();
    bundleResourceModule.getBundleInfo(item.bundleName, (bundleInfo: KeyValPair | PromiseLike<KeyValPair>) => {
      this.pageInfos.pushPath({ name: PageConstants.NTF_MGMT_VIEW_NAME, param: bundleInfo });
    }, item.appIndex);
  }
}
