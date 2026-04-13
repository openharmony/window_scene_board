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

import { ArrayUtils, CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { AppItemInfo, DesktopUtils, EditModeConstants } from '../../TsIndex';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { SmallFoldStyleUtil } from '../../utils/SmallFoldStyleUtil';
import { launcherStatusUtil } from '@ohos/windowscene/src/main/ets/TsIndex';
import lazy { OuterIconCenterViewModel } from '../viewmodel/OutIconCenterViewModel';
import { LazyDataSource } from '../../uicomponents/LazyDataSource';

const TAG = 'EditSearchComponentData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CAMERA_INPUT_MENU_ITEM_ID: TextMenuItemId = TextMenuItemId.of('OH_DEFAULT_CAMERA_INPUT');

@Observed
export class EditSearchComponentData {
  // 搜索栏管理器
  public mSearchStateMgr: EditSearchStateMgr = EditSearchStateMgr.getInstance();
  // 搜索栏内容
  public mSearchValue: string = '';
  // 搜索结果集合
  public mSearchResultList: LazyDataSource<AppItemInfo> = new LazyDataSource();
  // 搜索结果集合长度
  public mResultLen: number = 0;
  // 搜索栏参数
  public mSearchComponentParam: EditSearchComponentParam = new EditSearchComponentParam();
  // 搜索栏控制器
  public mController: SearchController = new SearchController();
  // 全局上下文
  public desktopContext: ServiceExtensionContext = GlobalContext.getContext();
  // 搜索栏字体大小
  public mFontSize: Length = EditModeConstants.OUTER_EDIT_SEARCH_COMPONENT_TEXT_SIZE;
  // 是否是卡片搜索栏
  public isForm: boolean = false;

  /**
   * 初始化数据
   *
   * @param searchComponentParam 搜索栏参数
   * @param isForm 是否是卡片搜索栏
   */
  public initData(searchComponentParam: EditSearchComponentParam, isForm: boolean): void {
    this.mSearchComponentParam = searchComponentParam;
    this.isForm = isForm;
    this.mFontSize = SmallFoldStyleUtil.getScaleSize(EditModeConstants.OUTER_EDIT_SEARCH_COMPONENT_TEXT_SIZE
      , SmallFoldStyleUtil.LEVEL_BIG_3_FONT_SIZE_SCALE);
  }

  /**
   * 重置搜索栏数据
   */
  public resetSearchData(): void {
    this.mSearchStateMgr.setMatchedValue('');
    this.mSearchResultList.clear();
    this.mResultLen = 0;
  }

  /**
   * 搜索栏数据改变事件
   *
   * @param inputValue 搜索栏内容
   */
  public onSearchValueChange(inputValue: string): void {
    this.mSearchValue = inputValue;
    this.setSearchStateWhenValueChange();
    let searchResultList: AppItemInfo[] = [];
    this.searchAppList(searchResultList, this.mSearchComponentParam.fullAppList);
    log.showInfo(`search result length: ${searchResultList.length}`);
    this.handleSearchResult(searchResultList);
  }

  private setSearchStateWhenValueChange(): void {
    if (this.mSearchStateMgr.getState() !== EditSearchState.FOCUSED) {
      this.mSearchStateMgr.setState(CheckEmptyUtils.checkStrIsEmpty(this.mSearchValue) ?
      EditSearchState.NONE : EditSearchState.EDITED);
    }
  }

  private handleSearchResult(resultList: AppItemInfo[]): void {
    if (this.mSearchStateMgr.getShowState() === EditSearchShowState.NOT_SHOW) {
      log.showInfo('search not show, no treatment');
      return;
    }
    // 搜索栏数据为空
    if (CheckEmptyUtils.checkStrIsEmpty(this.mSearchValue)) {
      this.resetSearchData();
      this.mSearchComponentParam.afterSearchCallback(EditModeConstants.OUTER_EDIT_SEARCH_NO_VALUE);
      return;
    }
    // 搜索结果为空
    if (resultList.length === 0) {
      this.resetSearchData();
      // 搜索结果为空, 可能应用已经被添加到外屏
      let searchResultListByAdded: AppItemInfo[] = []
      this.searchAppList(searchResultListByAdded, this.mSearchComponentParam.allAppListByAdded);
      // 不为0表示应用已经被添加到外屏
      if (searchResultListByAdded.length === 0) {
        this.mSearchComponentParam.afterSearchCallback(EditModeConstants.OUTER_EDIT_SEARCH_NO_RESULT);
      } else {
        this.mSearchComponentParam.afterSearchCallback(EditModeConstants.OUTER_EDIT_SEARCH_NO_RESULT_BY_IN_DESKTOP);
      }
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
    this.mSearchComponentParam.afterSearchCallback('', resultList);
  }

  /**
   * 基于string的indexOf方法的匹配查找
   *
   *  @param searchResultList 匹配的结果
   */
  private searchAppList(searchResultList: AppItemInfo[], targetList: AppItemInfo[]): void {
    let searchValueTrim = this.mSearchValue.toLocaleLowerCase().trim();
    if (searchValueTrim.length === 0) {
      return;
    }
    for (let item of targetList) {
      if (!item.applicationName) {
        log.showWarn(`applicationName invalid: ${item.applicationName}`);
        continue;
      }
      let index: number | undefined = OuterIconCenterViewModel.getInstance()
        .getLowerCaseAppNameMap().get(item.bundleName)?.indexOf(searchValueTrim);
      if (index != undefined && index !== -1) {
        searchResultList.push(item);
      }
    }
  }

  /**
   * 过滤拍摄输入菜单
   *
   * @param menuItems 输入框目前所有菜单
   * @returns 过滤后的菜单
   */
  public filterMenu(menuItems: Array<TextMenuItem>): Array<TextMenuItem> {
    // 内屏不受影响
    if (!launcherStatusUtil.getShowOutLauncherStatus()) {
      return menuItems;
    }
    let index: number = menuItems.findIndex((item) => {
      return item.id.equals(CAMERA_INPUT_MENU_ITEM_ID);
    });
    if (index !== -1) {
      menuItems.splice(index, 1);
    }
    return menuItems;
  }
}

export class EditSearchComponentParam {
  public afterSearchCallback: (bundleName?: string, searchResultList?: AppItemInfo[]) => void = () => {};
  public fullAppList: AppItemInfo[] = [];
  public allAppListByAdded: AppItemInfo[] = [];
}

export enum EditSearchState {
  // 不获焦，没内容
  NONE,

  // 正在搜索，即搜索框获焦
  FOCUSED,

  // 搜索框没获焦，但是有内容（即不全为空格）
  EDITED
}

export enum EditSearchShowState {
  // 搜索栏显示
  SHOW,

  // 搜索栏未显示
  NOT_SHOW
}

@Observed
export class EditSearchStateMgr {
  private static instance: EditSearchStateMgr;
  private state: EditSearchState = EditSearchState.NONE;
  private showState: EditSearchShowState = EditSearchShowState.NOT_SHOW;
  private matchedValue: string = '';

  /**
   * 单例
   *
   * @returns 搜索栏状态管理器
   */
  public static getInstance(): EditSearchStateMgr {
    if (!EditSearchStateMgr.instance) {
      EditSearchStateMgr.instance = new EditSearchStateMgr();
    }
    return EditSearchStateMgr.instance;
  }

  /**
   * 设置全局搜索栏内容
   *
   * @param matchedValue 搜索栏内容
   */
  public setMatchedValue(matchedValue: string): void {
    this.matchedValue = matchedValue;
  }

  /**
   * 获取全局搜索栏内容
   *
   * @returns 搜索栏内容
   */
  public getMatchedValue(): string {
    return this.matchedValue;
  }

  /**
   * 获取当前搜索栏显示状态
   *
   * @returns 搜索栏显示状态
   */
  public getShowState(): EditSearchShowState {
    return this.showState;
  }

  /**
   * 设置当前搜索栏显示状态
   *
   * @param showState 搜索栏显示状态
   */
  public setShowState(showState: EditSearchShowState): void {
    this.showState = showState;
  }

  /**
   * 获取当前搜索栏状态
   *
   * @returns 搜索栏状态
   */
  public getState(): EditSearchState {
    return this.state;
  }

  /**
   * 设置当前搜索栏状态
   *
   * @param state 搜索栏状态
   */
  public setState(state: EditSearchState): void {
    this.state = state;
  }
}