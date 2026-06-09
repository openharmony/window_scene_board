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
  LogDomain,
  LogHelper,
  SingletonHelper,
} from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { DeviceHelper, GlobalContext, HiSysEventUtil, localEventManager } from '@ohos/frameworkwrapper';
import { BusinessType } from '../../constants/CommonConstants';
import {
  EditModeConstants,
  editModeManager,
  EventConstants,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  PageInfoManager,
  LayoutViewModel,
  RdbStoreManager,
  lockLayoutManager,
} from '../../TsIndex';
import { EditModePageActionEnum, EditModePageUtil, getBlankPageListType } from '../data/PageEditData';
import { PageEditAdapter } from './PageEditAdapter';
import { PageDragManager } from './PageDragManager';
import { SwiperLoadData } from '@ohos/swiperdata/src/main/ets/TsIndex';
import { image } from '@kit.ImageKit';
import PageIndexTypeInfo from '../../bean/PageIndexTypeInfo';
import lazy { pocketPreferenceUtil } from '../../utils/PocketPreferenceUtil';
import { EditModeAccessibilityUtil } from '../utils/EditModeAccessibilityUtil';
import { DesktopUtils } from '../../utils/DesktopUtils';
import { IDesktopDataInfo } from '../../viewmodel/LayoutViewModel';

const TAG = 'PageEditManager';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

class DesktopDataInfo {
  public appGridInfo: GridLayoutItemInfo[][] = [[]];
  public waterfallItemListInfo: GridLayoutItemInfo[] = [];
}

export class PageEditManager {
  public readonly pageEditState: PageEditState = new PageEditState();
  public readonly editModeBlankAnimatePageData: EditModeBlankAnimatePageData = new EditModeBlankAnimatePageData();
  public readonly editModeDragAnimatePageData: EditModeDragAnimatePageData = new EditModeDragAnimatePageData();
  public readonly editModeDragPageTipTextData: EditModeDragPageTipTextData = new EditModeDragPageTipTextData();
  public readonly dragPageData: EditModeDragPageData = new EditModeDragPageData();
  public readonly editModeEditPageData: EditModeEditPageData = new EditModeEditPageData();
  /** 空白页 */
  public blankPageList: Map<number, boolean> = PageInfoManager.getInstance().getBlankPageList();
  public outerBlankPageList: Map<number, boolean> = PageInfoManager.getInstance().getBlankPageList(true);

  constructor() {
    PageEditAdapter.getInstance().getBlankPageList = this.getBlankPageList;
  }

  // 为PageEditAdapter中的getBlankPageList方法赋值
  private getBlankPageList: getBlankPageListType = (isOuter?: boolean) => {
    if (isOuter) {
      return this.outerBlankPageList;
    }
    return this.blankPageList;
  };

  public getRealBlankPageList(isOuter?: boolean): Map<number, boolean> {
    isOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    if (isOuter) {
      return this.outerBlankPageList;
    }
    return this.blankPageList;
  }

  /**
   * 添加页面按钮点击事件
   *
   * @param isOuter 是否是小外屏
   */
  public handleAddPage(isOuter: boolean): void {
    const layoutCacheMgr = LaunchLayoutCacheManager.getInstance();
    const pageCount = layoutCacheMgr.selectPageCount(isOuter);
    log.showInfo(`handleAddPage pageCount ${pageCount}`);
    let effectCount: number = PageInfoManager.getInstance().getDisplayCount();
    // 添加页面更新pageCount
    layoutCacheMgr.updatePageCount(pageCount + effectCount, 'update pageCount by editMode pageEdit', true, isOuter);
    AppStorage.setOrCreate(desktopUtil.getPageIndex(), desktopUtil.getPageIndexValue(isOuter));
    HiSysEventUtil.reportAddBlankPage(pageCount + effectCount);
    const desktopDataInfo: DesktopDataInfo =
      AppStorage.get(desktopUtil.getAppListInfo(isOuter)) as object as DesktopDataInfo;
    if (!desktopDataInfo) {
      log.showWarn(`handleAddPage desktopDataInfo is null`);
      return;
    }
    const currentMaxKey: number = SwiperLoadData.getInstance().getPageMaxValue();
    // 添加页面更新缓存及数据库
    desktopDataInfo.appGridInfo.push([]);
    pageEditManager.getRealBlankPageList(isOuter).set(currentMaxKey + 1, true);
    for (let i = 2; i <= effectCount; i++) {
      desktopDataInfo.appGridInfo.push([]);
      pageEditManager.getRealBlankPageList(isOuter).set(currentMaxKey + i, false);
    }
    let tempDataInfo: IDesktopDataInfo = {
      appGridInfo: desktopDataInfo.appGridInfo,
      waterfallItemListInfo: desktopDataInfo.waterfallItemListInfo
    };
    log.showInfo(`tempDataInfo.appGridInfo.length:${tempDataInfo.appGridInfo.length}`);
    LayoutViewModel.getInstance().updateDesktopLayoutData(tempDataInfo, 'addPageToAppGridInfo', isOuter);
    EditModeAccessibilityUtil.textAnnouncedForAddPageSuccess(pageCount + effectCount, pageCount + effectCount);
  }

  public customAddNewBlankPage(isOuter: boolean): void {
    const currentMaxKey: number = SwiperLoadData.getInstance().getPageMaxValue();
    pageEditManager.getRealBlankPageList(isOuter).set(currentMaxKey + 1, false);
  }

  /**
   * 删除页面按钮点击事件
   *
   * @param page 要删除的page的index
   * @param isOuter 是否是外屏
   */
  public async handleDeletePage(page: number, isOuter: boolean): Promise<void> {
    log.showInfo(`handleDeletPage pageIndex: ${page}`);
    if (PageInfoManager.getInstance().isHomePage(page)) {
      log.showInfo(`handleDeletePage, page ${page} is home page`);
      return;
    }
    const layoutCacheMgr = LaunchLayoutCacheManager.getInstance();
    const pageCount = layoutCacheMgr.selectPageCount(isOuter);
    let effectCount: number = PageInfoManager.getInstance().getDisplayCount();
    layoutCacheMgr.updatePageCount(
      pageCount - effectCount, BusinessType.BUSINESS_EDITMODE_PAGEEDIT, true, isOuter);
    AppStorage.setOrCreate(desktopUtil.getPageIndex(), page);
    HiSysEventUtil.reportDeleteBlankPage(pageCount - effectCount,
      LayoutViewModel.getInstance().isSimpleLauncherMode() ? 5 : 1);
    const pages: number[] = SwiperLoadData.getInstance().getPages().slice(0);
    for (let i = page; i < page + effectCount; i++) {
      if (pageEditManager.getRealBlankPageList(isOuter).has(pages[i])) {
        pageEditManager.getRealBlankPageList(isOuter).delete(pages[i]);
      }
    }
    layoutCacheMgr.updateLayoutAfterDeletePage(
      page, effectCount, 'delete page by editMode page Manager', undefined, isOuter
    )
    layoutCacheMgr.updateLayoutListCacheAndPrebuild(
      layoutCacheMgr.getAllGridLayoutItemList('editMode pageEdit', isOuter), isOuter
    )
    EditModeAccessibilityUtil.textAnnouncedForDeletePageSuccess(page + 1, pageCount - effectCount);
    log.showInfo(`handleDeletPage EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH`);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
  }

  /**
   * 拖拽页面
   *
   * @param startDragPageIndex 拖拽起始页index
   * @param endDragPageIndex 拖拽落位页index
   * @param isOuter 是否是小外屏
   */
  public async handleDragPage(startDragPageIndex: number, endDragPageIndex: number, isOuter: boolean): Promise<void> {
    log.showInfo(`handleDragPage startDragPageIndex: ${startDragPageIndex}, endDragPageIndex: ${endDragPageIndex}`);
    HiSysEventUtil.reportDragPage();
    const layoutCacheMgr = LaunchLayoutCacheManager.getInstance();
    const startPages: number[] = PageDragManager.getInstance().getRelativePages(startDragPageIndex);
    const endPages: number[] = PageDragManager.getInstance().getRelativePages(endDragPageIndex);
    layoutCacheMgr.updateLayoutAfterDragPage(
      startPages[0], endPages[0], 'delete page by editMode page Manager', undefined, isOuter
    )
    layoutCacheMgr.updateLayoutListCacheAndPrebuild(
      layoutCacheMgr.getAllGridLayoutItemList('editMode pageDrag', isOuter), isOuter
    )
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
  }

  /**
   * 更新折叠屏折叠展开态
   *
   * @param isExpand 是否展开
   */
  public onFoldStatusChange(isExpand: boolean): void {
    pageEditManager.pageEditState.isFoldExpandStatus = isExpand;
  }

  private originBlankPageList: PageIndexTypeInfo[] = [];
  private outerOriginBlankPageList: PageIndexTypeInfo[] = [];

  private initBlankPageListFlag = true;

  private getOriginBlankPageList(isOuter?: boolean): PageIndexTypeInfo[] {
    return isOuter ? this.outerOriginBlankPageList : this.originBlankPageList;
  }

  private setOriginBlankPageList(blankPageList: PageIndexTypeInfo[], isOuter?: boolean): void {
    if (isOuter) {
      this.outerOriginBlankPageList = blankPageList;
    } else {
      this.originBlankPageList = blankPageList;
    }
  }

  /**
   * 从数据库中获取空白页
   */
  public getBlankPageListFromRdb(): void {
    this.initBlankPageListFlag = true;
    RdbStoreManager.getInstance().queryAllPageIndexTypeInfo(LayoutViewModel.getInstance().isSimpleLauncherMode(), false)
      .then((result => {
        this.originBlankPageList = result;
        for (let i = 0; i < this.originBlankPageList.length; i++) {
          log.showInfo(`getBlankPageListFromRdb blankPageList ${result[i].pageIndex} ${result[i].type}`);
        }
      }));
  }

  /**
   * 从数据库中获取外屏空白页
   */
  public getOuterBlankPageListFromRdb(): void {
    return;
  }

  /**
   * 页面布局更新的时候向缓存和数据库中刷新空白页
   */
  public updateBlankPageList(isOuter?: boolean): void {
    isOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    const layoutCacheMgr = LaunchLayoutCacheManager.getInstance();
    const pageSet: Set<number> = new Set();
    layoutCacheMgr.getAllGridLayoutItemList(BusinessType.BUSINESS_EDITMODE_PAGEEDIT, isOuter)
      .forEach((item: GridLayoutItemInfo) => {
        if (typeof item.page !== 'undefined') {
          pageSet.add(item.page);
        }
      });
    const pageCount = layoutCacheMgr.selectPageCount(isOuter);
    let pages: number[] = SwiperLoadData.getInstance().getPages().slice(0);
    log.showInfo(`new pages ${pages}`);
    if (this.initBlankPageListFlag) {
      for (let i = 0; i < this.getOriginBlankPageList(isOuter).length; i++) {
        pageEditManager.getRealBlankPageList(isOuter).set(pages[this.getOriginBlankPageList(isOuter)[i].pageIndex], this.getOriginBlankPageList(isOuter)[i].type === 'added');
      }
      this.initBlankPageListFlag = false;
    }
    pageEditManager.getRealBlankPageList(isOuter).forEach((isBlankPage, blankPage) => {
      log.showInfo(`old blankPageList: ${blankPage} ${isBlankPage}`);
    });
    if (pages.length) {
      this.updateBlankPageListWhenReloadGridSwiper(pages, pageCount, pageSet, isOuter);
    };
  }

  /**
   * 更新空白页信息
   *
   * @param pages: 当前页面
   * @param pageCount: 页面数
   * @param pageSet: 存在元素的页面
   * @param originBlankPageList: 数据库中记录的空白页信息
   */
  public updateBlankPageListWhenReloadGridSwiper(
    pages: number[],
    pageCount: number,
    pageSet: Set<number>,
    isOuter?: boolean
  ): void {
    let blankPageIndexTypeInfoList: PageIndexTypeInfo[] = [];
    for (let i = 0; i < pageCount; i++) {
      // blankPageList中未记录的空白页记录进去，这里是非手动添加的空白页
      if (!pageSet.has(i) && !pageEditManager.getRealBlankPageList(isOuter).has(pages[i])) {
        pageEditManager.getRealBlankPageList(isOuter).set(pages[i], false);
      }
      // blankPageList中记录的空白页在当前布局中非空白页了
      if (pageSet.has(i) && pageEditManager.getRealBlankPageList(isOuter).has(pages[i])) {
        pageEditManager.getRealBlankPageList(isOuter).delete(pages[i]);
      }
    }
    for (let blankPage of pageEditManager.getRealBlankPageList(isOuter)) {
      if (!pages.includes(blankPage[0])) {
        // blankPageList中记录的空白页在当前布局中不存在了
        pageEditManager.getRealBlankPageList(isOuter).delete(blankPage[0]);
      } else {
        // 将blankPageList更新为数据库信息结构，准备向数据库中推送更新
        let blankPageIndexTypeInfo = new PageIndexTypeInfo();
        blankPageIndexTypeInfo.pageIndex = pages.indexOf(blankPage[0]);
        blankPageIndexTypeInfo.type = blankPage[1] ? 'added' : 'default';
        blankPageIndexTypeInfoList.push(blankPageIndexTypeInfo);
      }
    }
    log.showInfo(`isSimpleLauncherMode ${LayoutViewModel.getInstance().isSimpleLauncherMode()}`);
    pageEditManager.getRealBlankPageList(isOuter).forEach((isBlankPage, blankPage) => {
      log.showInfo(`new blankPageList: ${blankPage} ${isBlankPage}`);
    });
    GlobalContext.getContext()?.eventHub.emit(EditModeConstants.UPDATE_BLANK_PAGE_LIST);
    // 页面布局刷新后的空白页信息如果发生变化，则要更新数据库
    if (this.isBlankPageChange(this.getOriginBlankPageList(isOuter), blankPageIndexTypeInfoList)) {
      this.setOriginBlankPageList(blankPageIndexTypeInfoList, isOuter);
      RdbStoreManager.getInstance().updatePageIndexTypeInfoOfDb(
        blankPageIndexTypeInfoList,
        LayoutViewModel.getInstance().isSimpleLauncherMode(),
        isOuter ?? false
      );
    }
  };

  /**
   * 判断页面布局刷新前后的空白页信息是否发生变化
   *
   * @param originBlankPageList: 数据库中记录的空白页信息
   * @param newBlankPageList: 页面布局刷新后的空白页信息
   * @returns 空白页信息是否发生变化
   */
  private isBlankPageChange(originBlankPageList: PageIndexTypeInfo[], newBlankPageList: PageIndexTypeInfo[]): boolean {
    if (originBlankPageList.length !== newBlankPageList.length) {
      log.showInfo(`blankPageList.length changed`);
      return true;
    }
    const sortedOriginBlankPageList: PageIndexTypeInfo[] = originBlankPageList.sort((a, b) => {
      return a.pageIndex - b.pageIndex
    });
    const sortedNewBlankPageList: PageIndexTypeInfo[] = newBlankPageList.sort((a, b) => {
      return a.pageIndex - b.pageIndex
    });
    let changeFlag = false;
    for (let i = 0; i < sortedOriginBlankPageList.length; i++) {
      if (sortedOriginBlankPageList[i].pageIndex !== sortedNewBlankPageList[i].pageIndex ||
        sortedOriginBlankPageList[i].type !== sortedNewBlankPageList[i].type) {
        changeFlag = true;
      }
    }
    log.showInfo(`isBlankPageChange ${changeFlag}`);
    return changeFlag;
  }

  /**
   * 是否显示加号页
   * 当前显示加号页场景：
   * 编辑模式，未满18屏，非拖拽页面中
   */
  public canAddPageShow(): boolean {
    // 锁定布局时，不显示加号页和导航点的加号图标
    if (lockLayoutManager.isLockLayout()) {
      return false;
    }
    const layoutCacheMgr = LaunchLayoutCacheManager.getInstance();
    const pageCount = layoutCacheMgr.selectPageCount();
    const maxPageCount = layoutCacheMgr.selectMaxPageCount();
    return editModeManager.isInEditMode() &&
      pageCount < maxPageCount &&
      pageEditManager.dragPageData.dragPageState === EditModePageActionEnum.WAITTING_ACTION;
  }
}

@Observed
export class PageEditState {
  /** 当前是否是大折叠展开态 */
  public isFoldExpandStatus: boolean = EditModePageUtil.getIsFoldExpandStatus();
}

@Observed
export class EditModeBlankAnimatePageData {
  /** 新增空白页动效属性-显隐 */
  public showBlankAnimatePage: boolean = false;
  /** 新增空白页动效属性-大小 */
  public blankAnimatePageScale: number = 1;
  /** 新增空白页动效属性-透明度 */
  public blankAnimatePageOpacity: number = 1;
}

@Observed
export class EditModeDragAnimatePageData {
  /** 编辑模式背景板左上角据桌面左上角Y位置 */
  public editModeBgTopPointY: number = 0;
  // 拖拽页面用图标组件截图
  public dragSnapshot: image.PixelMap[] = [];
  // 编辑模式图标组件距离背板高度差
  public dragGridImageTopY: number = 0;
  // 编辑模式图标组件宽度
  public imageSizeWidth: number = 0;
  // 编辑模式图标组件高度
  public imageSizeHeight: number = 0;
}

@Observed
export class EditModeDragPageTipTextData {
  /** 编辑模式拖拽页面提示文本颜色 */
  public dragPageTipTextColor: string = '#FFFFFF';
  /** 编辑模式拖拽页面提示文本透明度 */
  public dragPageTipTextOpacity: number = EditModeConstants.DRAG_PAGE_TIP_OPACITY;
  /** 拖拽页面起拖页呼吸动效 */
  public dragAnimatePageScale: number = 1;
}

@Observed
export class EditModeDragPageData {
  /** 拖拽页状态 */
  public dragPageState: EditModePageActionEnum = EditModePageActionEnum.WAITTING_ACTION;
  /** 拖拽页面起拖页index */
  public startDragPageSwiperKey: number = 0;
}

@Observed
export class EditModeEditPageData {
  /** 新增删除空白页的空白页状态 */
  public handleEditPageState: EditModePageActionEnum = EditModePageActionEnum.WAITTING_ACTION;
  /** 增加删除页加号页显隐状态控制 */
  public canAddPageShow: boolean = false;
  /** 加号页动效属性，位置偏移 */
  public addPageTranslate: number = 0;
  /** 满屏删除最后一页，用于控制加号页出现动效 */
  public deletingLastBlankPage: boolean = false;
}

export const pageEditManager = SingletonHelper.getInstance(PageEditManager, TAG);


