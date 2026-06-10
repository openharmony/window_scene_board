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
  CommonConstants,
  DesktopUtils,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  LayoutDescription,
} from '@ohos/launchercommon';
import { DeskTopArray } from './SwiperPage';
import DesktopItem from './DesktopItem';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import featureConstants from '../constants/FeatureConstants';
import { PageDesktopViewModel } from '../viewmodel/PageDesktopViewModel';
import { GridItemsPool } from '../../manager/GridItemsPool';
import { DesktopAccessibilityUtils } from '../DesktopAccessibilityUtils';
import { ResourceManager, GlobalContext } from '@ohos/frameworkwrapper';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import context from '@ohos.app.ability.common';

const TAG = 'GridItemReuseComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const INVALID_IDX = -1;
const DESKTOP_MAX_ZINDEX = 1000;
const RESET_LOCATED_GRIDITEM_ZINDEX_EVENT_SUFFIX = 'RESET_LOCATED_GRIDITEM_ZINDEX_EVENT';

export class GridItemParams {
  public item: GridLayoutItemInfo = new GridLayoutItemInfo();
  public mPageDesktopViewModel?: PageDesktopViewModel;
  public mNameLines: number = 0;
  public mMaxNameLines: number = 0;
  public isPad: boolean = false;
  public mPageDesktopStyleConfig?: PageDesktopGridStyleConfig;
  public desktopList: DeskTopArray = new DeskTopArray();
  public iconSize: number = 0;
  public onItemSelect?: (item: GridLayoutItemInfo, pageIndex: number) => void;
  public isDesktopLayout: boolean = true;
  public indexInSwiper: number = 0;
  public swiperKey: number = 0;
  public selectedStatus: boolean = false;
}

@Builder
function gridItemBuilder(data: GridItemParams) {
  DesktopItemComponent({
    item: data.item,
    mPageDesktopViewModel: data.mPageDesktopViewModel,
    mNameLines: data.mNameLines,
    mMaxNameLines: data.mMaxNameLines,
    isPad: data.isPad,
    mPageDesktopStyleConfig: data.mPageDesktopStyleConfig,
    desktopList: data.desktopList,
    mIconSize: data.iconSize,
    onItemSelect: data.onItemSelect,
    isDesktopLayout: data.isDesktopLayout,
    indexInSwiper: data.indexInSwiper,
    swiperKey: data.swiperKey,
  })
}

@Component
struct DesktopItemComponent {
  private item: GridLayoutItemInfo = new GridLayoutItemInfo();
  private mPageDesktopViewModel?: PageDesktopViewModel;
  private mNameLines: number = 0;
  private mMaxNameLines: number = 0;
  private isPad: boolean = false;
  private mPageDesktopStyleConfig?: PageDesktopGridStyleConfig;
  private desktopList: DeskTopArray = new DeskTopArray();
  @State mIconSize: number = 0;
  onItemSelect?: (item: GridLayoutItemInfo, pageIndex: number) => void;
  private isDesktopLayout: boolean = true;
  @Prop indexInSwiper: number;
  private swiperKey: number = -1;
  @State selectedStatus: boolean = false;
  @Provide isShowingUninstallDialog: number = 0;
  @Provide dragToUninstallItemInfo: AppItemInfo = new AppItemInfo();

  build() {
    DesktopItem({
      item: this.item,
      mPageDesktopViewModel: this.mPageDesktopViewModel,
      mNameLines: this.mNameLines,
      mMaxNameLines: this.mMaxNameLines,
      isPad: this.isPad,
      mPageDesktopStyleConfig: this.mPageDesktopStyleConfig,
      mFileFolderOpacity: featureConstants.DEFAULT_ITEM_ALPHA,
      mTag: 'SwiperPage',
      isDesktopItem: true,
      desktopStyle: this.desktopList[DesktopUtils.getItemKey(this.item)],
      iconSize: this.mIconSize,
      onItemSelect: this.onItemSelect,
      isDesktopLayout: this.isDesktopLayout,
      getIndexInSwiper: (): number => this.indexInSwiper,
      swiperKey: this.swiperKey,
      selectedStatus: this.selectedStatus,
    })
  }
}

@Component
export struct GridItemReuseComponent {
  @StorageProp('transitionOutRegionFolders') transitionOutRegionFolders: string[] = [];
  @StorageProp('transitionInRegionFolders') transitionInRegionFolders: string[] = [];
  private item: GridLayoutItemInfo = new GridLayoutItemInfo();
  private mPageDesktopViewModel?: PageDesktopViewModel;
  private mNameLines: number = 0;
  private mMaxNameLines: number = 0;
  private isPad: boolean = false;
  private mPageDesktopStyleConfig?: PageDesktopGridStyleConfig;
  private desktopList: DeskTopArray = new DeskTopArray();
  @State mIconSize: number = 0;
  onItemSelect?: (item: GridLayoutItemInfo, pageIndex: number) => void;
  private isDesktopLayout: boolean = true;
  @Link indexInSwiper: number;
  private swiperKey: number = -1;
  @Link @Watch('selectedItemListChange') selectedItemList: string[];
  @Link isPreparingDrag: boolean;
  @StorageLink('itemPadding') mItemPadding: number = 0;
  private isPhone: boolean = false;
  @State selectedStatus: boolean = false;
  @StorageLink('aliveForm') aliveForm: GridLayoutItemInfo | undefined = undefined;
  @Link isAccessibilityMode: boolean;
  handleAccessibilityClick?: Function;
  doKeyEvent?: Function;
  getTransitionEffect?: Function;
  setHoverItem?: Function;
  getZIndex: Function = (): number => { return 0; };
  getIconPadding?: Function;
  @State gridItemZIndex: number = 0;
  // 设置Grid里GridItem的Z序,isTopLayer:表示是否提到最上层, ture提到最上层，false恢复默认Z序
  private resetLocatedGridItemZIndex: Function = (isTopLayer: boolean): void =>  {
    if (isTopLayer) {
      this.gridItemZIndex = DESKTOP_MAX_ZINDEX;
    } else {
      this.gridItemZIndex = this.getZIndex(this.item);
    }
    log.showInfo(`resetLocatedGridItemZIndex ${isTopLayer}, ${this.gridItemZIndex}, ${this.item?.ino}`);
  }

  private registerResetZIndexEvent(): void {
    const uiContext = GlobalContext.getInstance().getObject('desktopContext') as context.UIAbilityContext;
    uiContext.eventHub.on(this.getResetZIndexEventName(), this.resetLocatedGridItemZIndex);
  }

  private unRegisterResetZIndexEvent(): void {
    const uiContext = GlobalContext.getInstance().getObject('desktopContext') as context.UIAbilityContext;
    uiContext.eventHub.off(this.getResetZIndexEventName(), this.resetLocatedGridItemZIndex);
  }

  private getResetZIndexEventName(): string {
    return GridLayoutUtil.generateUniqueKey(this.item) + RESET_LOCATED_GRIDITEM_ZINDEX_EVENT_SUFFIX;
  }

  aboutToAppear(): void {
    this.registerResetZIndexEvent();
  }

  aboutToDisappear(): void {
    this.unRegisterResetZIndexEvent();
  }

  build() {
    GridItem() {
      NodeContainer(GridItemsPool.getInstance().getNode({
        item: this.item,
        mPageDesktopViewModel: this.mPageDesktopViewModel,
        mNameLines: this.mNameLines,
        mMaxNameLines: this.mMaxNameLines,
        isPad: this.isPad,
        mPageDesktopStyleConfig: this.mPageDesktopStyleConfig,
        desktopList: this.desktopList,
        iconSize: this.mIconSize,
        onItemSelect: this.onItemSelect,
        isDesktopLayout: this.isDesktopLayout,
        indexInSwiper: this.indexInSwiper,
        swiperKey: this.swiperKey,
        selectedStatus: this.selectedStatus,
      }, gridItemBuilder))
    }
    .zIndex(this.gridItemZIndex)
    .accessibilityLevel(DesktopAccessibilityUtils
      .getDesktopItemAccessibilityLevel(this.item, this.isAccessibilityMode))
    .accessibilityGroup(DesktopAccessibilityUtils
      .getDesktopItemAccessibilityGroup(this.item, this.isAccessibilityMode))
    .accessibilityText(DesktopAccessibilityUtils
      .getDesktopItemAccessibilityText(this.item, this.isAccessibilityMode))
    .onClick(this.isAccessibilityMode ? () => {
      this.handleAccessibilityClick?.(this.item);
    } : undefined)
    .accessibilityDescription(this.isAccessibilityMode ?
    ResourceManager.getInstance().getStringByName('tap_with_menu_reader_text') : '')
    .onTouch((event?: TouchEvent) => {
      if ((event?.type === TouchType.Up || event?.type === TouchType.Cancel) &&
        this.item?.typeId === CommonConstants.TYPE_APP) {
        AppStorage.setOrCreate('isIconTouch', false);
      } else if (event?.type === TouchType.Down && this.item?.typeId === CommonConstants.TYPE_APP) {
        AppStorage.setOrCreate('isIconTouch', true);
      }
    })
    .selected($$this.selectedStatus)
    .onSelect((isSelected) => {
      // only pc has rectangle select
      if (this.isPhone || !this.mPageDesktopViewModel) {
        return;
      }
      log.showInfo(`griditem onselect, isSelected: ${isSelected}`);
      let itemKey: string = this.mPageDesktopViewModel.getItemKeyByType(this.item);
      if (AppStorage.get<boolean>('isCtrlKeyDown')) {
        if (isSelected) {
          this.item.isSelect = !this.item.isSelect;
        }
      } else {
        this.item.isSelect = isSelected;
      }

      let index = this.selectedItemList.indexOf(itemKey);
      if (isSelected && this.item.typeId !== CommonConstants.TYPE_CARD &&
        this.item.typeId !== CommonConstants.TYPE_REGION_FOLDER) { // 卡片和分区文件夹不允许选中
        if (index === INVALID_IDX) {
          this.selectedItemList.push(itemKey);
        }
        this.mPageDesktopViewModel.onSelectItemChange(this.selectedItemList, this.item.isSelect);
      } else {
        if (index !== INVALID_IDX && !this.isPreparingDrag) {
          this.mPageDesktopViewModel.onSelectItemChange([itemKey], this.item.isSelect);
          this.selectedItemList.splice(index, 1);
        }
      }
    })
    .id(DesktopUtils.getGridItemId(this.indexInSwiper, this.item))
    .padding(this.getIconPadding?.(this.item))
    .onHover((isHover?: boolean) => {
      let isMouseCross: boolean = AppStorage.get('isMouseCross') as boolean;
      const isDrag: boolean = AppStorage.get('isDrag') as boolean;
      isMouseCross = isDrag ? true : isMouseCross;
      if (isMouseCross) {
        return;
      }
      this.setHoverItem?.(isHover, this.item);
    })
    .clip(CommonConstants.DEFAULT_CLIP_FALSE)
    .onDisAppear(() => {
      TraceUtil.endTrace(DomainName.HOME, TraceUtil.UNINSTALL_APP);
    })
    .onKeyEvent((event?: KeyEvent) => {
      log.showInfo(`onKeyEvent UniqueKey: ${GridLayoutUtil.generateUniqueKey(this.item)} type: ${event?.type}`);
      this.doKeyEvent?.(event, this.indexInSwiper);
    })
    .transition(this.getItemTransitionEffect())
  }

  private selectedItemListChange(): void {
    if (this.selectedItemList.length === 0) {
      this.selectedStatus = false;
    }
  }

  private getItemTransitionEffect(): TransitionEffect | undefined {
    return this.getTransitionEffect?.(this.item);
  }
}