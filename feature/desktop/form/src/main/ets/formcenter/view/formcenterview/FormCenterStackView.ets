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

import { LazyDataSource } from '@ohos/launchercommon/src/main/ets/uicomponents/LazyDataSource';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  AppItemInfo,
  CardItemInfo,
} from '@ohos/launchercommon';
import { ViewData } from '../../../default/viewmodel/FormCenterObservedData';
import ThisStyleConstants from '../../../default/common/constants/FormStyleConstants';
import TileLayout from '../layout/TileLayout';
import {
  NoResultComponent,
  SearchComponent,
  SearchStateMgr,
} from '../atomicview/SearchComponent';

import AppListItem from '../atomicview/AppListItem';
import { AppListItemEvent } from '../../viewmodel/event/AppListEvent';
import { FormCenterStackViewStyle } from '../../viewstyles/FormCenterStackViewStyle';
import { FormCenterStackViewInterface } from '../../interfaces/FormCenterStackViewInterface';
import { FormCenterCommonUtil } from '../../util/FormCenterCommonUtil';

const TAG = 'FormCenterStackView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export struct FormCenterStackView {
  public mRecommendedCardList: CardItemInfo[] = [];
  public mAppInfoList: LazyDataSource<AppItemInfo> = new LazyDataSource();
  public style: FormCenterStackViewStyle = new FormCenterStackViewStyle();
  public mEvent?: FormCenterStackViewInterface;
  private scroller: Scroller = new Scroller();
  private timer: number = -1;

  @ObjectLink mViewData: ViewData;
  @State mSearchStateMgr: SearchStateMgr = SearchStateMgr.getInstance();
  @State showMainContent: boolean = false;

  aboutToAppear(): void {
    // 延时10ms加载卡片中心List中的内容
    this.timer = setTimeout(() => {
      this.showMainContent = true;
    }, 10);

    if (this.mRecommendedCardList.length <= 0) {
      log.showInfo('mRecommendedCardList is empty');
      return;
    }
  }

  aboutToDisappear(): void {
    log.showInfo('FormCenterWithFormsView aboutToDisappear');
    clearTimeout(this.timer);
    this.timer = -1;
  }

  @Builder
  searchResultBuilder(appInfoList: LazyDataSource<AppItemInfo>) {
    if (!this.mSearchStateMgr.getIsNoResult()) {
      List() {
        this.AppListBuilder(appInfoList)
      }
      .padding({
        top: this.mRecommendedCardList.length > 0 ? this.style.searchListTop : this.style.searchListTopWithoutRecommend,
      })
      .margin({ top: this.style.getMarginTop(this.mRecommendedCardList.length > 0) })
      .width('100%')
      .constraintSize({ minHeight: 'calc(100% - 64)' })
      .height('100%')
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .onTouch(() => {
        FormCenterCommonUtil.clearSearchFocus(this.getUIContext());
      })
    } else {
      NoResultComponent({
        style: this.style.noResultStyle,
      })
    }
  }

  @Builder
  AppListBuilder(appInfoList: LazyDataSource<AppItemInfo>) {
    ListItemGroup() {
      LazyForEach(appInfoList, (item: AppItemInfo, index: number) => {
        ListItem() {
          AppListItem({
            appItem: item,
            style: this.style.appListItemStyle,
            appItemViewEvent: AppListItemEvent.getInstance(),
            idIndex: index as number,
            refreshFlag: this.mSearchStateMgr.refreshFlag,
          })
        }
        .width(this.mViewData.appListWidth - this.style.titleMargin * 2)
        .onClick(() => {
          log.showInfo(`onClick item: ${item.bundleName} index: ${index}`);
          this.mEvent?.onListItemClick(item);
        })
        .onTouch(() => {
          FormCenterCommonUtil.clearSearchFocus(this.getUIContext());
        })
      }, (item: AppItemInfo, index: number): string => {
        return `${item.bundleName}-${item.moduleName}-${item.abilityName}-${index}`;
      })
    }
    .divider({
      strokeWidth: this.style.dividerStrokeWidth,
      startMargin: this.style.dividerStartMargin,
      endMargin: this.style.dividerEndMargin,
      color: this.style.dividerColor,
    })
    .borderRadius(this.style.listItemBorderRadius)
    .backgroundColor(this.style.listItemBackGroundColor)
    .padding(this.style.listItemPadding)
    .margin(this.style.listItemMargin)
    .width(this.mViewData.bindSheetWidth - this.style.titleMargin * 2)
  }

  @Builder
  RecommendFormsBuilder() {
    Column() {
      TileLayout({
        mFormList: this.mRecommendedCardList,
        mViewData: this.mViewData.navDestinationViewData,
        style: this.style.tileLayoutStyle,
      })
    }
  }

  @Builder
  buildSearchComponent() {
    SearchComponent({
      mSearchComponentParam: this.mEvent?.getSearchComponentParam(),
      searchResultBuilder: (appInfoList: LazyDataSource<AppItemInfo>): void => this.searchResultBuilder(appInfoList),
      mStyle: this.style.searchComponentStyle,
    })
  }

  build() {
    Stack() {
      // 搜索组件
      if (this.style.isNeedSearch) {
        this.buildSearchComponent()
      }

      List({ scroller: this.scroller }) {
        if (this.showMainContent) {
          if (this.mRecommendedCardList.length > 0) {
            this.RecommendFormsBuilder()
          }
          if (this.mAppInfoList.totalCount() > 0 && !this.mSearchStateMgr.getIsShowSearchResult()) {
            this.AppListBuilder(this.mAppInfoList)
          }
        }
      }
      .scrollBar(this.style.scrollBar)
      .backgroundColor(this.style.listBgrColor)
      .padding({
        top: this.style.listPaddingTop - this.mRecommendedCardList.length > 0 ? this.style.listMarginTop :
          this.style.listMarginTopWithoutRecommend
      })
      .margin({ top: this.style.getMarginTop(this.mRecommendedCardList.length > 0) })
      .width(this.style.listWidth)
      .onTouch(() => {
        FormCenterCommonUtil.clearSearchFocus(this.getUIContext());
      })
      .opacity(this.mSearchStateMgr.getIsShowSearchResult() ? ThisStyleConstants.DEFAULT_FORM_HIDDEN_OPACITY_VALUE :　1)
      .enabled(!this.mSearchStateMgr.getIsShowSearchResult())
      .accessibilityLevel(this.mSearchStateMgr.getIsShowSearchResult() ? 'no-hide-descendants' : 'auto')
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })

      ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Vertical, state: BarState.Auto })
        .margin(this.style.scrollBarMargin)
    }
    .id('FormCenterStackView_Stack')
    .alignContent(this.style.stackAlignContent)
    .width(this.style.stackWidth)
    .height(this.style.stackHeight ?? this.mViewData.bindSheetHeight - this.style.titleHeight)
  }
}