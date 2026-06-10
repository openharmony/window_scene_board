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

import { LengthMetrics, uiAppearance, SymbolGlyphModifier } from '@kit.ArkUI';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { ArrayUtils, CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, ResourceManager } from '@ohos/frameworkwrapper';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import {
  AppItemInfo,
  CommonConstants,
  EditModeConstants,
  StyleConstants } from '@ohos/launchercommon';
import { LazyDataSource } from '@ohos/launchercommon/Index';
import FormStyleConstants from '../common/constants/FormStyleConstants';
import FormConstants from '../common/constants/FormConstants';
import StyleManager from '../manager/StyleManager';
import lazy {
  EditSearchStateMgr,
  EditSearchShowState
} from '@ohos/launchercommon/src/main/ets/outerdesktop/viewmodel/EditSearchComponentData'

const TAG = 'SearchComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class SearchComponentParam {
  public afterSearchCallback: (bundleName?: string) => void = () => {};
  public fullAppList: AppItemInfo[] = [];
}

@Component
export struct SearchComponent {
  @State mSearchStateMgr: SearchStateMgr = SearchStateMgr.getInstance();
  @State mSearchValue: string = '';
  @State mSearchResultList: LazyDataSource<AppItemInfo> = new LazyDataSource();
  @State @Watch('resultChange') mResultLen: number = 0;
  @State mEditSearchStateMgr: EditSearchStateMgr = EditSearchStateMgr.getInstance();
  private mSearchComponentParam: SearchComponentParam = new SearchComponentParam();
  private mController: SearchController = new SearchController();
  private desktopContext: ServiceExtensionContext = GlobalContext.getContext();
  private mFontSize: Length = FormStyleConstants.SEARCH_COMPONENT_FONT_SIZE;
  private titleMargin: number = FormStyleConstants.FORM_MANAGER_TITLE_MARGIN;

  @Builder defaultListBuilder(appInfoList: LazyDataSource<AppItemInfo>) {}
  @BuilderParam searchResultBuilder: (appInfoList: LazyDataSource<AppItemInfo>) => void = this.defaultListBuilder;

  aboutToAppear(): void {
    this.desktopContext?.eventHub.on(FormConstants.CLOSE_KEYBOARD_OF_FORM_CENTER,
      () => { this.mController.stopEditing(); });
    this.desktopContext?.eventHub.on(FormConstants.RESET_SEARCH, () => { this.mSearchValue = ''; });
    this.mFontSize = this.getFontSize(FormStyleConstants.SEARCH_COMPONENT_FONT_SIZE);
    this.adaptAlias();
    this.resultChange();
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.desktopContext?.eventHub.on(EditModeConstants.SET_FORM_SEARCH_VALUE,
        (value: string) => { this.onSearchValueChange(value); });
    }
  }

  aboutToDisappear(): void {
    this.desktopContext?.eventHub.off(FormConstants.CLOSE_KEYBOARD_OF_FORM_CENTER);
    this.desktopContext?.eventHub.off(FormConstants.RESET_SEARCH);
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.desktopContext?.eventHub.off(EditModeConstants.SET_FORM_SEARCH_VALUE);
    }
  }

  private resultChange() {
    this.mSearchStateMgr.setIsNoResult(this.mResultLen === 0);
  }

  /**
   * 适配一键锁屏卡片的别名
   */
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
    log.showWarn(`use alias, bundle: ${aliasCopy.bundleName}, alias: ${aliasCopy.applicationName}`);
  }

  /**
   * search组件暂不支持maxFontScale，临时方案
   * 获取界面的字体放大倍数，超过1.45倍按照1.45倍算
   * 等search组件支持maxFontScale后, 可以删除
   *
   * @param defaultValue 当获取出错时返回的默认值
   * @returns Length 字体大小
   */
  private getFontSize(defaultValue: number): Length {
    try {
      const curScale: number = uiAppearance.getFontScale();
      const fontSize: string = `${Math.min(curScale, StyleConstants.FONT_MAX_SCALE_FORM_TEXT) * defaultValue}vp`;
      log.showWarn(`default size: ${defaultValue}, cur scale: ${curScale}, final size: ${fontSize}`);
      return fontSize;
    } catch (err) {
      log.showError(`getFontSize error:${err.message}`);
    }
    return `${defaultValue}vp`;
  }

  /**
   * 基于string的indexOf方法的匹配查找
   *
   *  @param searchResultList 匹配的结果
   */
  private searchAppList(searchResultList: AppItemInfo[]): void {
    let searchValueTrim = this.mSearchValue.toLocaleLowerCase().trim();
    if (searchValueTrim.length === 0) {
      return;
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
  }

  private resetSearchData(): void {
    this.mSearchStateMgr.setMatchedValue('');
    this.mSearchResultList.clear();
    this.mResultLen = 0;
  }

  private handleSearchResult(resultList: AppItemInfo[]): void {
    // 输入为空，重置搜索数据，显示全量列表
    if (CheckEmptyUtils.checkStrIsEmpty(this.mSearchValue)) {
      this.resetSearchData();
      if (launcherStatusUtil.getShowOutLauncherStatus()) {
        return;
      }
      this.mSearchComponentParam.afterSearchCallback();
      return;
    }

    // 输入不为空，但结果为空，显示占位图
    if (resultList.length === 0) {
      this.resetSearchData();
      this.mSearchComponentParam.afterSearchCallback(FormConstants.NO_SEARCH_RESULT);
      return;
    }

    this.mSearchStateMgr.setMatchedValue(this.mSearchValue.toLocaleLowerCase().trim());
    // 上次搜索的appList
    let preSearchList: AppItemInfo[] = [];
    for (let index = 0; index < this.mSearchResultList.totalCount(); index++) {
      let item: AppItemInfo = this.mSearchResultList.getData(index);
      preSearchList.push(item);
    }

    // 两次搜索结果相同，不处理
    if (ArrayUtils.equalsArr(resultList, preSearchList)) {
      log.showInfo('same result');
      return;
    }

    this.mSearchResultList.clear();
    for (let item of resultList) {
      this.mSearchResultList.pushItem(item);
    }
    this.mResultLen = this.mSearchResultList.totalCount();
    this.mSearchResultList.notifyDataReload();
    this.mSearchComponentParam.afterSearchCallback(this.mSearchResultList.getData(0).bundleName);
  }

  private setSearchStateWhenValueChange(): void {
    if (this.mSearchStateMgr.getState() !== SearchState.FOCUSED) {
      this.mSearchStateMgr.setState(CheckEmptyUtils.checkStrIsEmpty(this.mSearchValue) ?
      SearchState.NONE : SearchState.EDITED);
    }
  }

  private onSearchValueChange(inputValue: string): void {
    this.mSearchValue = inputValue;
    this.setSearchStateWhenValueChange();
    let searchResultList: AppItemInfo[] = [];
    this.searchAppList(searchResultList);
    log.showWarn(`search result length: ${searchResultList.length}`);
    this.handleSearchResult(searchResultList);
    if (launcherStatusUtil.getShowOutLauncherStatus() &&
      this.mEditSearchStateMgr.getShowState() === EditSearchShowState.SHOW) {
      this.mSearchStateMgr.setIsShowSearchResult(true);
      return;
    }
    this.mSearchStateMgr.setIsShowSearchResult(!CheckEmptyUtils.checkStrIsEmpty(this.mSearchValue));
  }

  build() {
    Stack() {
      Search({
        value: this.mSearchValue,
        placeholder: $r('app.string.search'),
        controller: this.mController,
      })
        .margin({
          start: LengthMetrics.vp(this.titleMargin),
          end: LengthMetrics.vp(this.titleMargin),
          top: LengthMetrics.vp(FormStyleConstants.FORM_CENTER_FORM_TOP_MARGIN),
        })
        .textFont({ size: this.mFontSize })
        .placeholderFont({ size: this.mFontSize })
        .searchIcon(new SymbolGlyphModifier($r('sys.symbol.magnifyingglass')).fontSize(this.mFontSize))
        .cancelButton({ icon: new SymbolGlyphModifier($r('sys.symbol.xmark')).fontSize(this.mFontSize) })
        .borderRadius($r('sys.float.corner_radius_level12'))
        .fontColor($r('sys.color.font_primary'))
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .draggable(false)
        .defaultFocus(false)
        .onFocus(() => {
          this.mSearchStateMgr.setState(SearchState.FOCUSED);
        })
        .onBlur(() => {
          this.mSearchStateMgr.setState(CheckEmptyUtils.checkStrIsEmpty(this.mSearchValue) ?
          SearchState.NONE : SearchState.EDITED);
        })
        .onSubmit((value) => {
          this.onSearchValueChange(value);
        })
        .onChange((value) => {
          this.onSearchValueChange(value);
        })
        .visibility(launcherStatusUtil.getShowOutLauncherStatus() ? Visibility.Hidden : Visibility.Visible)

      if (!(launcherStatusUtil.getShowOutLauncherStatus() && CheckEmptyUtils.checkStrIsEmpty(this.mSearchValue))) {
        // 搜索结果的列表
        if (!CheckEmptyUtils.checkStrIsEmpty(this.mSearchValue)) {
          this.searchResultBuilder(this.mSearchResultList);
        }
      }
    }
    .alignContent(Alignment.TopStart)
    .width('100%')
    .height('100%')
  }
}

@Component
export struct NoResultComponent {
  build() {
    Column() {
      Image($r('app.media.search_no_result'))
        .width(StyleManager.getNoResultStyle().imageWidth)
        .height(StyleManager.getNoResultStyle().imageWidth)
        .margin({ bottom: FormStyleConstants.SEARCH_RESULT_EMPTY_MARGIN_BOTTOM })
        .draggable(false)
      Text($r('app.string.no_matching_results'))
        .fontColor($r('sys.color.font_tertiary'))
        .fontSize(FormStyleConstants.SEARCH_RESULT_EMPTY_FONT_SIZE)
        .fontWeight(StyleManager.getNoResultStyle().promptWeight)
        .draggable(false)
    }
    .width('100%')
    .margin({ top: StyleManager.getNoResultStyle().marginTop })
  }
}

@Component
export struct OuterNoResultComponent {
  build() {
    Column() {
      Image($r('app.media.search_no_result'))
        .width(FormStyleConstants.OUTER_SEARCH_RESULT_EMPTY_LENGTH)
        .height(FormStyleConstants.OUTER_SEARCH_RESULT_EMPTY_LENGTH)
        .draggable(false)
      Text($r('app.string.no_matching_results'))
        .fontColor($r('sys.color.font_tertiary'))
        .fontSize(FormStyleConstants.SEARCH_RESULT_EMPTY_FONT_SIZE)
        .fontWeight(StyleManager.getNoResultStyle().promptWeight)
        .draggable(false)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .offset({ y: -4 })
  }
}

export enum SearchState {
  // 不获焦，没内容
  NONE,

  // 正在搜索，即搜索框获焦
  FOCUSED,

  // 搜索框没获焦，但是有内容（即不全为空格）
  EDITED,
}

@Observed
export class SearchStateMgr {
  private matchedValue: string = '';
  private state: SearchState = SearchState.NONE;
  private isShowSearchResult: boolean = false;
  private isNeedSearch: boolean = false;
  private isNoResult: boolean = false;
  private static instance: SearchStateMgr;

  public static getInstance(): SearchStateMgr {
    if (!SearchStateMgr.instance) {
      SearchStateMgr.instance = new SearchStateMgr();
    }
    return SearchStateMgr.instance;
  }

  public getState(): SearchState {
    return this.state;
  }

  public setState(state: SearchState): void {
    this.state = state;
  }

  public getIsShowSearchResult(): boolean {
    return this.isShowSearchResult;
  }

  public setIsShowSearchResult(isShowSearchResult: boolean): void {
    this.isShowSearchResult = isShowSearchResult;
  }

  public getIsNeedSearch(): boolean {
    return this.isNeedSearch;
  }

  public setIsNeedSearch(isNeedSearch: boolean): void {
    this.isNeedSearch = isNeedSearch;
  }

  public getIsNoResult(): boolean {
    return this.isNoResult;
  }

  public setIsNoResult(isNoResult: boolean): void {
    this.isNoResult = isNoResult;
  }

  public setMatchedValue(matchedValue: string): void {
    this.matchedValue = matchedValue;
  }

  public getMatchedValue(): string {
    return this.matchedValue;
  }
}