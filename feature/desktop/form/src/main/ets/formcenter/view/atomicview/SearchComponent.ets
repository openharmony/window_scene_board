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

import { SymbolGlyphModifier, uiAppearance } from '@kit.ArkUI';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  AppItemInfo, StyleConstants,
} from '@ohos/launchercommon';
import { LazyDataSource } from '@ohos/launchercommon/Index';
import FormStyleConstants from '../../../default/common/constants/FormStyleConstants';
import { SearchComponentInterface, SearchComponentStateData } from '../../interfaces/SearchComponentInterface';
import { SearchComponentEvent } from '../../viewmodel/event/SearchComponentEvent';
import { SearchComponentStyle } from '../../viewstyles/SearchComponentStyle';
import { NoResultStyle } from '../../viewstyles/NoResultStyle';
import { SingleAppResult } from '../../util/FusionSearchUtil';
import { FormCenterCommonUtil } from '../../util/FormCenterCommonUtil';

const TAG = 'SearchComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class SearchComponentParam {
  public afterSearchCallback: (bundleName?: string) => void = () => {};
  public fullAppList: AppItemInfo[] = [];
}

@Component
export struct SearchComponent {
  public mSearchComponentParam: SearchComponentParam = new SearchComponentParam();
  public mController: SearchController = new SearchController();
  public mEvent: SearchComponentInterface = new SearchComponentEvent();
  public mStyle: SearchComponentStyle = new SearchComponentStyle();
  private mFontSize: Length = this.mStyle.fontSize;
  @State mSearchStateMgr: SearchStateMgr = SearchStateMgr.getInstance();
  @State mStateData: SearchComponentStateData = new SearchComponentStateData();
  @State mSearchResultList: LazyDataSource<AppItemInfo> = new LazyDataSource();

  @Builder defaultListBuilder(appInfoList: LazyDataSource<AppItemInfo>) {}
  @BuilderParam searchResultBuilder: (appInfoList: LazyDataSource<AppItemInfo>) => void = this.defaultListBuilder;

  aboutToAppear(): void {
    this.mFontSize = this.getFontSize(FormStyleConstants.SEARCH_COMPONENT_FONT_SIZE);
    this.mEvent.init(this.mSearchResultList, this.mSearchComponentParam, this.mController,
      this.mStateData, () => {
      this.mStateData.searchValue = '';
    });
    this.mEvent.onAppear();
  }

  aboutToDisappear(): void {
    this.mEvent.onDisAppear();
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

  build() {
    Stack() {
      Search({
        value: this.mStateData.searchValue,
        placeholder: $r('app.string.search'),
        controller: this.mController,
      })
        .margin(this.mStyle.searchMargin)
        .textFont({ size: this.mFontSize })
        .placeholderFont({ size: this.mFontSize })
        .searchIcon(new SymbolGlyphModifier($r('sys.symbol.magnifyingglass')).fontSize(this.mFontSize))
        .cancelButton({ icon: new SymbolGlyphModifier($r('sys.symbol.xmark')).fontSize(this.mFontSize) })
        .borderRadius(this.mStyle.searchRadius)
        .fontColor(this.mStyle.searchFontColor)
        .backgroundColor(this.mStyle.searchBgrColor)
        .draggable(false)
        .defaultFocus(this.mStyle.searchDefaultFocus)
        .onFocus(() => {
          this.mSearchStateMgr.setState(SearchState.FOCUSED);
          this.mEvent.onFocus?.();
        })
        .onBlur(() => {
          this.mSearchStateMgr.setState(CheckEmptyUtils.checkStrIsEmpty(this.mStateData.searchValue) ?
            SearchState.NONE : SearchState.EDITED);
          this.mEvent.onBlur?.();
        })
        .onSubmit((value) => {
          this.mStateData.searchValue = value;
          this.mEvent.onSubmit(value);
        })
        .onChange((value) => {
          this.mStateData.searchValue = value;
          this.mEvent.onChange(value);
        })
        .visibility(this.mStyle.visibility)

      if (this.mSearchStateMgr.getIsShowSearchResult()) {
        if (!CheckEmptyUtils.checkStrIsEmpty(this.mStateData.searchValue)) {
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
  public style: NoResultStyle = new NoResultStyle();

  build() {
    Column() {
      Image(this.style.noResultImage)
        .width(this.style.noResultImageLength)
        .height(this.style.noResultImageLength)
        .margin({ bottom: FormStyleConstants.SEARCH_RESULT_EMPTY_MARGIN_BOTTOM })
        .draggable(false)

      Text(this.style.noResultText)
        .fontColor(this.style.noResultFontColor)
        .fontSize(this.style.noResultFontSize)
        .fontWeight(this.style.noResultFontWeight)
        .draggable(false)
    }
    .onTouch(() => {
      FormCenterCommonUtil.clearSearchFocus(this.getUIContext());
    })
    .width(this.style.noResultColumnWidth)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .height('100%')
    .zIndex(-1)
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
  // bundleName -> singleAppResult
  public parsedSearchResult: Map<string, SingleAppResult> = new Map();
  public refreshFlag: boolean = false;

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