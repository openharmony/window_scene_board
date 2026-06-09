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
import {
  DropdownVm,
  INotificationCardVm,
  NotificationVmInjector
} from '@ohos/systemuicommon/newIndex';
import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { NotificationMoreHeaderView } from './NotificationMoreHeaderView';
import { NotificationCardView } from './NotificationCardView';
import { NotificationStyle } from '../constants/NotificationStyle';
import { MORE_NTF_HEADER_DELETE_TRANSITION } from '../animation/MoreNotificationCollapsedAnimation';
import { NotificationSwipeVm } from '../viewmodel/NotificationSwipeVm';
import { EventManagerAdapter } from '@ohos/systemuicommon';
import { obtainStartAbilityWithWant } from '@ohos/frameworkwrapper';
import { LengthMetrics } from '@kit.ArkUI';
import { ResUtils } from '@ohos/windowscene';

const TAG = 'NotificationListView';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
/**
 * 更多通知折叠展开动效id
 */
const EXTRA_NTF_TRANSITION_ID: string = 'extra_ntf_transition_id_';
const LIST_COMPONENT_TAG: string = 'NotificationListComponent';

interface NotificationListItemParam {
  ntf: NotificationBase;
  cardVm: INotificationCardVm;
  index: number;
}

@ComponentV2
export struct NotificationListView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;

  @Computed
  get listVm() {
    return this.ntfVmInjector.getListVm();
  }

  @Computed
  get panelVm() {
    return this.ntfVmInjector.getPanelVm();
  }

  @Computed
  get scrollerVm() {
    return this.ntfVmInjector.getListScrollerVm();
  }

  @Computed
  get dataPlanVm() {
    return this.ntfVmInjector.getDataPlanVm()!;
  }

  private colorVm = this.ntfVmInjector.getColorVm();

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.dataPlanVm?.init();
  }

  aboutToDisAppear(): void {
    log.showInfo(`aboutToDisAppear`);
    this.dataPlanVm?.destroy();
  }

  build() {
    Column() {
      if (this.panelVm?.isLandscapeLayout && this.dataPlanVm.isShowDataPlan) {
        this.buildLandscapeShowData()
      }
      List({ space: this.scrollerVm?.space, scroller: this.scrollerVm?.scroller }) {
        // 一键删除场景组件不下树，保证动效完整
        if (this.listVm?.isEmpty && !this.ntfVmInjector.getClearButtonVm()?.isClearingAll) {
          this.buildEmptyTip()
        } else {
          Repeat(this.listVm?.mainNtfList).each((data) => {
            if (this.listVm!.mainNtfList[data.index]) {
              this.buildListItem({
                ntf: this.listVm!.mainNtfList[data.index],
                cardVm: this.listVm!.mainNtfList[data.index] &&
                this.ntfVmInjector.getCardVm(this.listVm!.mainNtfList[data.index]),
                index: data.index,
              })
            }
          }).key((ntf) => ntf.hashCode)

          // moreHeader和moreList分开写if判断，否则transition退场动效会互相影响
          if (this.listVm?.moreNtfList.length) {
            this.buildMoreHeaderItem()
          }
          if (this.listVm?.moreNtfList.length) {
            Repeat(this.listVm.displayedMoreNtfList).each((data) => {
              if (this.listVm!.moreNtfList[data.index]) {
                this.buildMoreListItem({
                  ntf: this.listVm!.moreNtfList[data.index],
                  cardVm: this.listVm!.moreNtfList[data.index] &&
                  this.ntfVmInjector.getCardVm(this.listVm!.moreNtfList[data.index]),
                  index: data.index,
                })
              }
            }).key((ntf) => ntf.hashCode)
          }

          if (this.listVm?.isShowBottomTransCard) {
            // 新增一个透明占位卡片，使滑动到最底部与一键删除垃圾桶不重叠
            this.buildTransparentCard();
          }
        }
      }
      .id(this.ntfVmInjector.getId(LIST_COMPONENT_TAG))
      .width(this.listVm?.width)
      .height(this.listVm?.height)
      .scale(this.listVm?.scale)
      .clipShape(this.listVm?.clipShape)
      .cachedCount(this.ntfVmInjector.getMoreVm()?.isExtraNtfsCollapseStatusChanging ? 0 : 6,
        this.listVm?.isGroupExpanding || this.listVm?.isDataUpdating || !this.panelVm?.isResponsive)
      .edgeEffect(EdgeEffect.Spring)
      .scrollBar(this.scrollerVm?.barState)
      .onScrollStart(this.scrollerVm?.onStartScroll)
      .onScrollStop(this.scrollerVm?.onStopScroll)
      .onWillScroll(this.scrollerVm?.onWillScroll)
      .onDidScroll(this.scrollerVm?.onDidScroll)
      .onScrollIndex(this.scrollerVm?.onScrollIndex)
      .onSizeChange((_, size) => {
        this.ntfVmInjector.getPanelVm().cardWidth = size.width as number;
        this.scrollerVm?.onListSizeChange(size);
        this.listVm?.onListSizeChange(size);
      })
      .contentStartOffset(this.listVm?.contentStartOffset)
      .enableScrollInteraction(this.listVm?.isScrollEnable)
      .accessibilityScrollTriggerable(this.listVm?.isScrollEnable)
    }
    .id(this.ntfVmInjector.getId(TAG))
    .translate({ y: this.listVm?.translateY })
    .animation(this.listVm?.reboundAnim)
    .layoutWeight(this.listVm?.layoutWeight)
    .accessibilityLevel('no')
    .margin(this.listVm?.margin)
    .alignRules(this.listVm?.alignRules)
    .clip(true)
  }

  @Builder
  buildEmptyTip() {
    ListItem() {
      Text($r('app.string.ntf_empty_text_tip'))
        .id(`${TAG}_empty`)
        .fontColor($r('app.color.ntf_phone_common_font_color'))
        .fontSize($r('app.float.ntf_empty_font_size'))
        .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .textAlign(TextAlign.Center)
        .offset(this.listVm?.emptyTextOffset)
        .alignRules({center: { anchor: '__container__', align: VerticalAlign.Center }})
    }
    .height(this.listVm?.emptyTextHeight)
    .id(this.ntfVmInjector.getId(`${TAG}_EmptyTip`))
    .transition(TransitionEffect.OPACITY.animation({ duration: 100, curve: Curve.Friction, delay: 100 }))
  }

  @Builder
  buildTransparentCard() {
    ListItem() {}
    .id(this.ntfVmInjector.getId(`${TAG}_TransparentCard`))
    .accessibilityLevel('no')
    .height(this.listVm?.transparentCardHeight)
    .opacity(0)
    .width('100%')
  }

  @Builder
  buildListItem(data: NotificationListItemParam) {
    ListItem() {
      if (data.ntf && data.cardVm) {
        NotificationCardView({ ntf: data.ntf, index: data.index })
      }
    }
    .id(this.listVm?.getItemId(data.ntf))
    .zIndex(data.cardVm?.zIndex)
    .transition(data.cardVm?.getTransitionAnimation())
    .onClick(() => {
      NotificationSwipeVm.reset();
    })
    .accessibilityLevel('no')
    .onSizeChange(() => this.listVm?.onListItemSizeChange())
  }

  @Builder
  buildMoreListItem(data: NotificationListItemParam) {
    ListItem() {
      if (data.ntf && data.cardVm) {
        // if-else中用isButtonCollapsed作为判断条件，实际点击折叠展开时应用转场，保证组件入场、出场的transition动效执行
        if (!this.ntfVmInjector.getNotificationMoreHeaderVm()?.isButtonCollapsed) {
          this.buildCollapsedMoreCardView(data);
        } else {
          this.buildExpandMoreCardView(data);
        }
      }
    }
    .id(this.listVm?.getItemId(data.ntf))
    .zIndex(data.cardVm?.getMoreNtfZIndex(data.index))
    .transition(data.cardVm?.getTransitionAnimation())
    .onClick(() => {
      NotificationSwipeVm.reset();
    })
    .accessibilityLevel('no')
    .onSizeChange(() => this.listVm?.onListItemSizeChange())
    .clip(this.listVm?.getIsFirstMoreNtfChanging(data.index) ? true : false)
    .borderRadius(this.listVm?.getIsFirstMoreNtfChanging(data.index) ? $r('app.float.ntf_list_content_border_radius') :
      0)
    .backgroundColor(this.listVm?.getIsFirstMoreNtfChanging(data.index) ?
      this.ntfVmInjector.getColorVm()?.ntfCardBgColor : undefined)
    .backgroundBrightnessInternal(this.listVm?.getIsFirstMoreNtfChanging(data.index) ?
      this.ntfVmInjector.getColorVm()?.cardBgBrightness : undefined)
  }

  @Builder
  buildCollapsedMoreCardView(data: NotificationListItemParam) {
    NotificationCardView({ ntf: data.ntf, index: data.index })
      .geometryTransition(EXTRA_NTF_TRANSITION_ID + data.ntf?.groupKey,
        { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
  }

  @Builder
  buildExpandMoreCardView(data: NotificationListItemParam) {
    NotificationCardView({ ntf: data.ntf, index: data.index })
      .geometryTransition(EXTRA_NTF_TRANSITION_ID + data.ntf?.groupKey,
        { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
  }

  @Builder
  buildMoreHeaderItem() {
    ListItem() {
      NotificationMoreHeaderView()
    }
    .id(this.ntfVmInjector.getId(`${TAG}_MoreHeader`))
    .transition(MORE_NTF_HEADER_DELETE_TRANSITION)
  }

  @Builder
  buildLandscapeShowData() {
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
    .zIndex(1)
    .padding({
      left: ResUtils.getNumber($r('app.float.data_plan_left_right_padding')),
      right: ResUtils.getNumber($r('app.float.data_plan_left_right_padding'))
    })
    .margin({ bottom: ResUtils.getNumber($r('app.float.data_plan_margin_bottom')) })
    .width(this.listVm?.width)
    .id(this.dataPlanVm.getId(`dataView`))
    .foregroundBrightness(this.colorVm.headerContentFgBrightness)
    .draggable(false)
    .scale({ x: this.dataPlanVm?.dataTextScale, y: this.dataPlanVm?.dataTextScale })
    .opacity(this.dataPlanVm?.dataTextOpacity)
    .translate({ y: this.dataPlanVm?.dataTextTranslateY })
    .animation(this.dataPlanVm?.followAnim)
    // 由于横屏时，column组件padding的top值，有通知时为8vp，无通知时为0
    // 因此在利用offset移动距离时需要将8vp的差距加上，不然会导致有无通知时组件高度跳变
    .offset({
      y: this.listVm?.isEmpty ? ResUtils.getNumber($r('app.float.status_bar_phone_height')) +
      ResUtils.getNumber($r('app.float.ntf_land_title_padding_top')) :
      ResUtils.getNumber($r('app.float.status_bar_phone_height'))
    })
    .justifyContent(this.dataPlanVm.isTianShuiConnected ? FlexAlign.End : FlexAlign.Start)
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