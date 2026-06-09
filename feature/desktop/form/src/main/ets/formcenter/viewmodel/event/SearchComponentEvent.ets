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
  ArrayUtils,
  CheckEmptyUtils,
  CommonUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { launcherStatusUtil, ResUtils } from '@ohos/windowscene';
import {
  AccessibilityManager,
  DeviceHelper,
  GlobalContext,
  ResourceManager,
} from '@ohos/frameworkwrapper';
import {
  AppItemInfo,
  CommonConstants,
  EditModeConstants,
  FormCenterViewManager,
} from '@ohos/launchercommon';
import { LazyDataSource } from '@ohos/launchercommon/Index';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import FormConstants from '../../../default/common/constants/FormConstants';
import { SearchComponentInterface, SearchComponentStateData } from '../../interfaces/SearchComponentInterface';
import { SearchComponentParam, SearchState, SearchStateMgr } from '../../view/atomicview/SearchComponent';
import {
  EditSearchStateMgr,
  EditSearchShowState
} from '@ohos/launchercommon/src/main/ets/outerdesktop/viewmodel/EditSearchComponentData';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { SingleAppResult, FusionSearchUtil } from '../../util/FusionSearchUtil';

const TAG = 'SearchComponentEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class SearchComponentEvent implements SearchComponentInterface {
  private mSearchStateMgr: SearchStateMgr = SearchStateMgr.getInstance();
  private stateData: SearchComponentStateData = new SearchComponentStateData();
  private mSearchResultList: LazyDataSource<AppItemInfo> = new LazyDataSource();
  private mEditSearchStateMgr: EditSearchStateMgr = EditSearchStateMgr.getInstance();
  private mSearchComponentParam: SearchComponentParam = new SearchComponentParam();
  private mController: SearchController = new SearchController();
  private desktopContext: ServiceExtensionContext = GlobalContext.getContext();
  private mResultLen: number = 0;
  private clearInputCallBack?: () => void = () => {};
  private appItemMap: Map<String, AppItemInfo> = new Map();
  private fusionSearchUtil: FusionSearchUtil = new FusionSearchUtil();

  init(mSearchResultList: LazyDataSource<AppItemInfo>,
    mSearchComponentParam: SearchComponentParam,
    mController: SearchController,
    stateData: SearchComponentStateData,
    clearInputCallBack?: () => void) {
    this.mSearchResultList = mSearchResultList;
    this.mSearchComponentParam = mSearchComponentParam;
    this.mController = mController;
    this.stateData = stateData;
    this.clearInputCallBack = clearInputCallBack;

    this.mSearchComponentParam.fullAppList.forEach((item: AppItemInfo) => {
      this.appItemMap.set(item.bundleName, item);
    })
  }

  onAppear(): void {
    this.desktopContext?.eventHub.on(FormConstants.CLOSE_KEYBOARD_OF_FORM_CENTER,
      () => { this.mController.stopEditing(); });
    this.desktopContext?.eventHub.on(FormConstants.RESET_SEARCH, () => { this.clearInputCallBack?.(); });
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.desktopContext?.eventHub.on(EditModeConstants.SET_FORM_SEARCH_VALUE,
        (value: string) => { this.onSearchValueChange(value); });
    }
    this.adaptAlias();
    this.resultChange();
  }

  onDisAppear(): void {
    this.desktopContext?.eventHub.off(FormConstants.CLOSE_KEYBOARD_OF_FORM_CENTER);
    this.desktopContext?.eventHub.off(FormConstants.RESET_SEARCH);
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.desktopContext?.eventHub.off(EditModeConstants.SET_FORM_SEARCH_VALUE);
    }
    this.mSearchStateMgr.setState(SearchState.NONE);
    this.fusionSearchUtil.destroy();
  }

  onSubmit(value: string): void {
    this.onSearchValueChange(value);
  }

  onChange(value: string): void {
    this.onSearchValueChange(value);
  }

  isShowResult(searchValue: string): boolean {
    return !CheckEmptyUtils.checkStrIsEmpty(searchValue);
  }

  public onFocus(): void {
    this.fusionSearchUtil.preConnect();
  }

  private async adaptAlias(): Promise<void> {
    if (CheckEmptyUtils.isEmptyArr(this.mSearchComponentParam.fullAppList)) {
      log.showWarn('empty list');
      return;
    }
    this.mSearchComponentParam.fullAppList = [...this.mSearchComponentParam.fullAppList];
    let aliasItemIndex: number =
      this.mSearchComponentParam.fullAppList.findIndex(item => item.bundleName === CommonConstants.SCENEBOARD_BUNDLE);

    if (aliasItemIndex === -1) {
      log.showWarn('no alias item');
      return;
    }

    let aliasCopy: AppItemInfo = ObjectCopyUtil.deepClone(this.mSearchComponentParam.fullAppList[aliasItemIndex]);
    aliasCopy.applicationName = ResourceManager.getInstance().getStringByName('lock_screen');
    this.mSearchComponentParam.fullAppList[aliasItemIndex] = aliasCopy;
    log.showWarn(`use alias, budle: ${aliasCopy.bundleName}, alias: ${aliasCopy.applicationName}`);
  }

  /**
   * 基于string的indexOf方法的匹配查找
   *
   *  @param searchResultList 匹配的结果
   */
  private searchAppList(searchResultList: AppItemInfo[]): Map<string, SingleAppResult> {
    let resultMap: Map<string, SingleAppResult> = new Map();

    let searchValueTrim = this.stateData.searchValue.toLocaleLowerCase().trim();
    if (searchValueTrim.length === 0) {
      return resultMap;
    }

    for (let item of this.mSearchComponentParam.fullAppList) {
      if (!item.applicationName) {
        log.showWarn(`applicationName invalid: ${item.bundleName}`);
        continue;
      }

      let index: number = item.applicationName.toLocaleLowerCase().indexOf(searchValueTrim);
      if (index !== -1) {
        searchResultList.push(item);
      }
    }

    searchResultList.forEach((item: AppItemInfo) => {
      let result: SingleAppResult = {appName: item.applicationName?.replace(searchValueTrim,
        `<em>${searchValueTrim}</em>`) ?? '', descriptionMap: new Map()};
      resultMap.set(item.bundleName, result);
    })
    return resultMap;
  }

  /**
   * 基于融合搜的查找
   *
   *  @param searchResultList 匹配的结果
   */
  private async fusionSearchAppList(searchResultList: AppItemInfo[]): Promise<Map<string, SingleAppResult>> {
    let resultMap: Map<string, SingleAppResult> = new Map();
    resultMap = await this.fusionSearchUtil.fusionSearch(this.stateData.searchValue);
    for (const bundleName of resultMap.keys()) {
      let appItem: AppItemInfo | undefined = this.appItemMap.get(bundleName);
      appItem && searchResultList.push(appItem);
    }
    return resultMap.size > 0 ? resultMap : this.searchAppList(searchResultList);
  }

  private resultChange() {
    this.mSearchStateMgr.setIsNoResult(this.mResultLen === 0);
    this.mSearchStateMgr.refreshFlag = !this.mSearchStateMgr.refreshFlag;
  }

  private resetSearchData(): void {
    this.mSearchStateMgr.setMatchedValue('');
    this.mSearchStateMgr.parsedSearchResult = new Map();
    this.mSearchResultList.clear();
    this.mResultLen = 0;
    this.resultChange();
  }

  private announceSearchResult() {
    if (!AccessibilityManager.getInstance().getIsAccessibilityMode() ||
      this.mSearchStateMgr.getState() !== SearchState.FOCUSED) {
      return;
    }

    let resultLen: number = this.mSearchStateMgr.parsedSearchResult.size;
    try {
      let announceText: string = ResUtils.getInnerPluralByResource($r('app.plural.search_result_accessibility_text'),
        resultLen);
      AccessibilityManager.getInstance().sendTextAnnouncedForAccessibility(announceText,
        'search_result_accessibility_text');
    } catch (err) {
      log.showError(`get announce text error: ${err?.code}, ${err.message}`);
    }
  }

  private handleSearchResult(resultList: AppItemInfo[]): void {
    // 输入为空，重置搜索数据，显示全量列表
    if (CheckEmptyUtils.checkStrIsEmpty(this.stateData.searchValue)) {
      this.resetSearchData();
      if (launcherStatusUtil.getShowOutLauncherStatus()) {
        return;
      }
      this.mSearchComponentParam.afterSearchCallback();
      return;
    }

    // 防抖1s播出搜索结果
    CommonUtils.debounce((): void => this.announceSearchResult(), 1000)();

    // 输入不为空，但结果为空，显示占位图
    if (resultList.length === 0) {
      this.resetSearchData();
      this.mSearchComponentParam.afterSearchCallback(FormConstants.NO_SEARCH_RESULT);
      return;
    }

    this.mSearchStateMgr.setMatchedValue(this.stateData.searchValue.toLocaleLowerCase().trim());
    // 上次搜索的appList
    let preSearchList: AppItemInfo[] = [];
    for (let index = 0; index < this.mSearchResultList.totalCount(); index++) {
      let item: AppItemInfo = this.mSearchResultList.getData(index);
      preSearchList.push(item);
    }

    // 两次搜索结果相同，不处理
    if (ArrayUtils.equalsArr(resultList, preSearchList)) {
      log.showInfo('same result');
      this.mSearchStateMgr.refreshFlag = !this.mSearchStateMgr.refreshFlag;
      return;
    }

    this.mSearchResultList.clear();
    for (let item of resultList) {
      this.mSearchResultList.pushItem(item);
    }
    this.mResultLen = this.mSearchResultList.totalCount();
    this.mSearchResultList.notifyDataReload();
    this.resultChange();
    this.mSearchComponentParam.afterSearchCallback(this.mSearchResultList.getData(0).bundleName);

    // 设置加桌页拉起方式为通过搜索
    FormCenterViewManager.getInstance().setOpenAddFormViewSource(FormConstants.FORM_MANAGER_SHOW_FROM_SEARCH);
  }

  private setSearchStateWhenValueChange(): void {
    if (this.mSearchStateMgr.getState() !== SearchState.FOCUSED) {
      this.mSearchStateMgr.setState(CheckEmptyUtils.checkStrIsEmpty(this.stateData.searchValue) ?
      SearchState.NONE : SearchState.EDITED);
    }
  }

  private async onSearchValueChange(inputValue: string): Promise<void> {
    this.stateData.searchValue = inputValue;
    this.setSearchStateWhenValueChange();
    let searchResultList: AppItemInfo[] = [];
    this.mSearchStateMgr.parsedSearchResult = await this.fusionSearchAppList(searchResultList);
    log.showWarn(`search result length: ${searchResultList.length}`);
    this.handleSearchResult(searchResultList);
    if (launcherStatusUtil.getShowOutLauncherStatus() &&
      this.mEditSearchStateMgr.getShowState() === EditSearchShowState.SHOW) {
      this.mSearchStateMgr.setIsShowSearchResult(true);
      return;
    }
    this.mSearchStateMgr.setIsShowSearchResult(!CheckEmptyUtils.checkStrIsEmpty(this.stateData.searchValue));
  }
}