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

import {
  AppItemInfo,
  CardItemInfo,
  FormModel,
} from '@ohos/launchercommon';
import { LazyDataSource } from '@ohos/launchercommon/src/main/ets/uicomponents/LazyDataSource';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ViewData } from '../../../default/viewmodel/FormCenterObservedData';
import {
  SearchComponent,
  SearchComponentParam,
  SearchStateMgr,
} from '../atomicview/SearchComponent';
import AppListItem from '../atomicview/AppListItem';
import { FormCenterSplitViewStyle } from '../../viewstyles/FormCenterSplitViewStyle';
import FormStyleConstants from '../../../default/common/constants/FormStyleConstants';
import { FormCenterViewModel } from '../../viewmodel/FormCenterViewModel';
import { FormCenterSplitEventInterface } from '../../interfaces/FormCenterSplitEventInterface';
import { NavEvent } from '../../viewmodel/event/NavEvent';
import { NavDestinationParam } from '../../interfaces/NavDestinationBuilderInterface';
import { FormCenterCommonUtil } from '../../util/FormCenterCommonUtil';

const TAG = 'FormCenterSplitView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export struct FormCenterSplitView {
  public mViewData: ViewData = new ViewData();
  public mAppInfoList: LazyDataSource<AppItemInfo> = new LazyDataSource<AppItemInfo>();
  public mSearchComponentParam: SearchComponentParam = new SearchComponentParam();
  public mEvent?: FormCenterSplitEventInterface = new NavEvent();
  public style: FormCenterSplitViewStyle = new FormCenterSplitViewStyle();
  public mFormCenterViewModel: FormCenterViewModel = FormCenterViewModel.getInstance();
  public mRecommendedCardList: CardItemInfo[] = [];
  private formCenterPage: NavPathStack = new NavPathStack();

  @Consume @Watch('onPreSetIndexChange') preSetIndex: number;
  @State clickIndex: number = 0;
  @Consume mStartFormInfo: CardItemInfo;
  @State mSearchStateMgr: SearchStateMgr = SearchStateMgr.getInstance();
  @Provide mNavFocusable: boolean = false;

  aboutToAppear(): void {
    this.mEvent?.initData(this.mStartFormInfo, this.formCenterPage);
    this.initSearchParam();
    this.clickIndex = this.mEvent?.getInitIndex() ?? 0;
    this.mEvent?.onAppear?.();
    log.showInfo(`appList length: ${this.mAppInfoList.totalCount()} start index: ${this.clickIndex}`);
  }

  aboutToDisappear(): void {
    this.mEvent?.onDisAppear?.();
    log.showInfo('FormCenterWithFormsView aboutToDisappear');
  }

  private onPreSetIndexChange(): void {
    this.clickIndex = this.preSetIndex;
    this.mEvent?.onIndexChange(this.preSetIndex);
  }

  /**
   * 搜索结果改变的回调
   */
  private afterSearchCallback(bundleName?: string): void {
    if (this.mAppInfoList.totalCount() <= 0) {
      return;
    }
    let pathName: string = bundleName ? bundleName : this.mAppInfoList.getData(0).bundleName;

    // 规避场景： 页面跳转的时候设置导航组件不可获焦，否则会导致与搜索框抢焦点，键盘收起
    this.mNavFocusable = false;
    this.clickIndex = 0;
    this.mEvent?.pushPathByName(pathName);
    // 导航动画大概150ms,需要等待动画结束后再设置获焦，否则还是会收起键盘
    let focusDelay: number = 300;
    setTimeout(() => { this.mNavFocusable = true; }, focusDelay);
  }

  private initSearchParam(): SearchComponentParam {
    this.mSearchComponentParam.fullAppList = FormCenterViewModel.getInstance().getAppList();
    this.mSearchComponentParam.afterSearchCallback = (bundleName) => this.afterSearchCallback(bundleName);
    return this.mSearchComponentParam;
  }

  private getCardList(name: string): CardItemInfo[] {
    if (name === FormStyleConstants.FORM_CENTER_DEFAULT_ITEM) {
      return this.mRecommendedCardList;
    }
    return FormModel.getInstance()
      .getAppItemTotalFormInfo(name, (item: CardItemInfo) => FormModel.getInstance().isFormCenterSupportCard(item)) ??
      [];
  }

  @Builder
  formShowPage(name: string, param?: NavDestinationParam) {
    this.mEvent?.getBuildInterface({name: name}).buildView().builder({
      cardList: this.getCardList(name),
      navDestinationViewData: this.mViewData.navDestinationViewData,
      name: name,
      destinationParam: param,
      appInfo: this.mFormCenterViewModel.getAppInfo(name),
      style: this.style,
    })
  }

  @Builder
  buildSearchComponent() {
    SearchComponent({
      mSearchComponentParam: this.mSearchComponentParam,
      searchResultBuilder: (appInfoList: LazyDataSource<AppItemInfo>): void => this.buildAppInfoList(appInfoList),
      mStyle: this.style.searchStyle,
    })
  }

  @Builder
  buildAppInfoList(appInfoList: LazyDataSource<AppItemInfo>) {
    List({ initialIndex: this.clickIndex }) {
      LazyForEach(appInfoList, (item: AppItemInfo, index: number) => {
        ListItem() {
          AppListItem({
            appItem: item,
            style: this.style.appListItemStyle,
            idIndex: index as number,
            refreshFlag: this.mSearchStateMgr.refreshFlag,
            clickIndex: this.clickIndex,
          })
        }
        .margin(this.style.listItemMargin)
        .onClick((event: ClickEvent) => {
          log.showInfo(`onClick item: ${item.bundleName} index: ${index}`);
          if (this.clickIndex === index) {
            return;
          }
          this.clickIndex = index;
          this.mEvent?.pushPathByName(item.bundleName);
          this.mEvent?.onListItemClick?.(event, item.bundleName);
        })
        .onTouch(() => {
          FormCenterCommonUtil.clearSearchFocus(this.getUIContext());
        })
        .width(this.mViewData.appListWidth - this.style.titleMargin * 2)
      }, (item: AppItemInfo, index: number): string => {
        return `${item.bundleName}-${item.moduleName}-${item.abilityName}-${index}`;
      })
    }
    .onFocus(() => {
      log.showDebug('list on focus, set navigation destination focusable');
      this.mNavFocusable = true;
    })
    .margin(this.style.listMargin)
    .width(this.style.listWidth)
  }

  build() {
    Navigation(this.formCenterPage) {
      Stack() {
        // 搜索组件
        if (this.style.isNeedSearch) {
          this.buildSearchComponent()
        }

        if (!this.mSearchStateMgr.getIsShowSearchResult()) {
          this.buildAppInfoList(this.mAppInfoList)
        }
      }
      .height(this.style.stackHeight)
      .width(this.style.stackWidth)
      .alignContent(this.style.stackAlignContent)
      .margin(this.style.stackMargin)
    }
    .id(`${TAG}_Navigation`)
    .margin(this.style.navMargin)
    .hideTitleBar(this.style.navHideTitleBar)
    .navBarWidth(this.mViewData.appListWidth)
    .mode(NavigationMode.Split)
    .navDestination(this.formShowPage)
    .height(this.style.navHeight ?? this.mViewData.navDestinationViewData.viewHeight)
    .width(this.style.navWidth ?? this.mViewData.bindSheetWidth)
  }
}