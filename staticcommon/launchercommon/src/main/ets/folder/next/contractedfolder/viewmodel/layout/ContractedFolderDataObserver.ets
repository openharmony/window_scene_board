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

import { image } from '@kit.ImageKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AccessibilityManager } from '@ohos/frameworkwrapper';
import { EditModeFolderViewData } from '../../../../../editmode/data/EditModeFolderViewData';
import { editModeManager, EditModeViewState, FolderAppItemInfo, GridLayoutItemInfo } from '../../../../../TsIndex';
import { BadgeAnimationType } from '../../../../../uicomponents/CustomBadge';
import { FolderAnimationPlaybackManager } from '../../../common/dfx/playback/FolderAnimationPlaybackManager';
import { FolderAccessibilityUtil } from '../../../common/FolderAccessibilityUtil';
import { OBSERVER_DATA } from '../../../common/FolderCommonConstant';
import { FoldersData } from '../../../common/model/data/FoldersData';
import { BaseDataObserver } from '../../../common/observer/BaseDataObserver';
import { SmallFolderDataObserver } from '../../../common/observer/SmallFolderDataObserver';
import { ContractedFolderObserver } from './ContractedFolderObserver';
import { ContractedFolderMode, ContractedFolderObserverType } from './IContractedFolderObserver';

const TAG = 'ContractedFolderDataObserver';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 折叠态文件夹View组件的控制接口，仅对View使用，数据状态变量
 */
export class ContractedFolderDataObserver extends ContractedFolderObserver {
  protected type: number = ContractedFolderObserverType.CONTRACTED_FOLDER_DATA;
  @Track public key: string = TAG;
  @Track public cycle: FolderAnimationPlaybackManager = FolderAnimationPlaybackManager.getInstance();
  @Track public editModeViewState: EditModeViewState = editModeManager.getEditModeViewState();
  @Track public editModeFolderViewData: EditModeFolderViewData = editModeManager.getEditModeFolderViewData();
  @Track public editFolderAnimationFolderItems: FolderAppItemInfo[] = [];
  /* 元素所在列 */
  @Track public columnIndex: number = 0;
  /* 元素所在行 */
  @Track public rowIndex: number = 0;
  /* 文件夹名字相关状态变量 */
  @Track public folderName: string = '';
  /* 文件夹数据状态变量 */
  @Track public folderDataOsr: BaseDataObserver = new BaseDataObserver('');
  /* 文件夹多选拖拽参数 */
  @Track private selectNames: string[] = [];
  /* 无障碍播报文件夹折叠态内容 */
  @Track public accessibilityText: string = '';

  /**
   * 注册observer
   *
   * @param folderId 文件夹id
   */
  public register(folderId: string): void {
    super.register(folderId);
    this.key = folderId + '_contracted_folder_data_observer';
  }


  /**
   * 获取observer类型
   *
   * @returns
   */
  public getObserverType(): number {
    return this.type;
  }

  /**
   * 初始化文件夹数据的observer
   *
   * @param folderData 文件夹数据
   * @param isSmall 是否小文件夹
   */
  public initObserver(folderData: FoldersData, isSmall: boolean): void {
    this.folderName = folderData.getFolderName();
    let item: GridLayoutItemInfo = folderData.getGridInfo();
    let folderId: string = item.folderId ?? '';
    this.rowIndex = item.row ?? 0;
    this.columnIndex = item.column ?? 0;
    log.showWarn(`initDataObs ${this.key}: area=[${item.area}] folderSize [${folderData.getItems().length}]`);
    this.folderDataOsr = new SmallFolderDataObserver(folderId);
    this.folderDataOsr.init(folderData);
    // 无障碍模式下重启机器的需要初始化无障碍文本，否则可能存在时序问题
    if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
      this.accessibilityText = FolderAccessibilityUtil.getFolderReaderText(folderId, isSmall,
        this.folderDataOsr.badgeNum);
    }
  }

  updateBadge(items: GridLayoutItemInfo[]): void {
    this.folderDataOsr.updateBadge(items);
  }

  getBadgeNumber(): number {
    return this.folderDataOsr.badgeNum;
  }

  updateBadgeAniType(type: BadgeAnimationType): void {
    this.folderDataOsr.badgeAniType = type;
  }

  /**
   * 更新文件夹数据
   *
   * @param msg 用于DFX日志
   * @param type 更新的数据类型
   * @param items 元素列表
   */
  public setData(msg: string, type: number, items: GridLayoutItemInfo[] | FolderAppItemInfo[]): void {
    log.showInfo(`(${msg}), update folder ${this.key} data for ${type} length: ${items.length}`);
    switch (type) {
      case OBSERVER_DATA.FIRST_PAGE_DATA:
        this.folderDataOsr.setFirstPageItems(items as GridLayoutItemInfo[]);
        break;
      case OBSERVER_DATA.END_PAGE_DATA:
        this.folderDataOsr.setEndPageItems(items as GridLayoutItemInfo[]);
        break;
      case OBSERVER_DATA.CURRENT_PAGE_DATA:
        this.folderDataOsr.setCurrentPageItems(items as GridLayoutItemInfo[]);
        break;
      case OBSERVER_DATA.HIDE_ITEMS_DATA:
        this.editFolderAnimationFolderItems = items as FolderAppItemInfo[];
        break;
      default:
        break;
    }
  }

  /**
   * 获取数据列表
   *
   * @param type 数据的类型
   * @returns
   */
  public getData(type: number): GridLayoutItemInfo[] | FolderAppItemInfo[] {
    switch (type) {
      case OBSERVER_DATA.FIRST_PAGE_DATA:
        return this.folderDataOsr.firstPageItems;
      case OBSERVER_DATA.END_PAGE_DATA:
        return this.folderDataOsr.endPageItems;
      case OBSERVER_DATA.CURRENT_PAGE_DATA:
        return this.folderDataOsr.currentPageItems;
      default:
        break;
    }
    return [];
  }

  /**
   * 更新截图
   *
   * @param msg DFX日志
   * @param type 截图类型
   * @param image 截图
   */
  public setImage(msg: string, type: number, image: image.PixelMap): void {
    log.showInfo('(%{public}s), update folder %{public}s image for %{public}d', msg, this.key, type);
    switch (type) {
      case OBSERVER_DATA.FIRST_PAGE_DATA:
        this.folderDataOsr.setFirstPageIcon(image);
        break;
      case OBSERVER_DATA.END_PAGE_DATA:
        this.folderDataOsr.setEndPageIcon(image);
        break;
      case OBSERVER_DATA.CURRENT_PAGE_DATA:
        this.folderDataOsr.setCurrentPageIcon(image);
        break;
      default:
        break;
    }
  }

  /**
   * 获取截图
   *
   * @param type 数据类型
   * @returns
   */
  public getImage(type: number): image.PixelMap | null {
    switch (type) {
      case OBSERVER_DATA.FIRST_PAGE_DATA:
        return this.folderDataOsr.getFirstPageIcon();
      case OBSERVER_DATA.END_PAGE_DATA:
        return this.folderDataOsr.getEndPageShowIcon();
      case OBSERVER_DATA.CURRENT_PAGE_DATA:
        return this.folderDataOsr.getCurrentPageIcon();
      default:
        break;
    }
    return null;
  }

  /**
   * 获取文件夹堆叠元素foreach子组件的key值
   *
   * @param keyname 元素的keyname
   * @param index 图标在列表的index
   * @param countInRow 每行显示的元素个数
   * @returns
   */
  public getStackItemKey(keyname: string | undefined, index: number, countInRow: number): string {
    if (countInRow === 0) {
      return keyname + '_' + this.columnIndex + '_' + this.rowIndex;
    }
    let stackIndex: number = this.folderDataOsr.firstPageItems.length + index;
    return keyname +
      '_' + (this.columnIndex + Math.floor(stackIndex / countInRow)) +
      '_' + (this.rowIndex + stackIndex % countInRow);
  }

  /**
   * 设置文件夹名字
   *
   * @param folderName 文件夹名字
   */
  public setFolderName(folderName: string): void {
    this.folderName = folderName;
  }

  /**
   * 设置文件夹显示的模式
   *
   * @param mode 网格或截图
   */
  public setMode(msg: string, mode: ContractedFolderMode): void {
    log.showWarn(`set ${this.key} mode to ${mode} from ${msg}`);
    this.cycle.record(this.key, msg, Number(this.folderDataOsr.contractedMode), Number(mode), 0, 0, -1);
    this.folderDataOsr.contractedMode = mode;
  }

  /**
   * 是否显示截图
   *
   * @returns true文件夹显示截图, false显示网格
   */
  public isFolderImageMode(): boolean {
    return this.folderDataOsr.contractedMode === ContractedFolderMode.MODE_IMAGE;
  }

  /**
   * 设置多选选中元素的keyname列表
   *
   * @param selectNames 选中元素的keyname列表
   */
  public setSelectItemNames(selectNames: string[]): void {
    this.selectNames = selectNames;
  }

  /**
   * 获取多选选中元素的keyname列表
   *
   * @returns 选择元素的keyname列表
   */
  public getSelectItemNames(): string[] {
    return this.selectNames;
  }

  /**
   * 更新文件夹折叠态无障碍播报内容
   * @param value
   */
  public updateAccessibilityText(value: string) {
    log.showInfo(`accessibilityText is ${value}`);
    this.accessibilityText = value;
  }
}