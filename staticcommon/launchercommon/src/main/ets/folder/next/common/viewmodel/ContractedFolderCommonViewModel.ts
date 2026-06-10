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
  ContractedFolderLayoutStyle,
  ContractedFolderViewModelManager,
  ContractedFolderViewModelType,
  DockItemInfo,
  FolderDragItem,
  FolderOperationFlag,
  GridLayoutItemInfo,
  IContractedFolderDragViewModel,
  IContractedFolderEventViewModel,
  IContractedFolderOpenCloseViewModel,
  IContractedFolderRenameViewModel,
  IContractedFolderUninstallViewModel,
  MenuInfo,
  MenuInfoType
} from '../../../../TsIndex';
import { FolderDropType } from '../FolderCommonConstant';
import { Callback } from '@kit.BasicServicesKit';

const TAG = 'ContractedFolderCommonViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹feature层ViewModel交互管理类
 */
export class ContractedFolderCommonViewModel {
  private static instance: ContractedFolderCommonViewModel;

  private quitAppCallback: (folderStyle: ContractedFolderLayoutStyle) => void =
    (folderStyle: ContractedFolderLayoutStyle): void => {};

  private mWaitFolderMenuDisappearCall: Callback<void>[] = [];

  private buildMenuCall: ((menu: MenuInfoType) => MenuInfo[]) | undefined;

  private constructor() {
    log.showInfo('ContractedFolderCommonViewModel constructor');
  }

  public static getInstance(): ContractedFolderCommonViewModel {
    if (!ContractedFolderCommonViewModel.instance) {
      ContractedFolderCommonViewModel.instance = new ContractedFolderCommonViewModel();
    }
    return ContractedFolderCommonViewModel.instance;
  }

  /**
   * 应用启动退出场景，注册的文件夹布局样式变化监听
   *
   * @param callback 监听回调
   */
  registerQuitAppListener(callback: (folderStyle: ContractedFolderLayoutStyle) => void): void {
    this.quitAppCallback = callback;
  }

  /**
   * 执行应用退出样式变化回调
   *
   * @param folderStyle 文件夹样式
   */
  public execQuitAppStyleListener(folderStyle: ContractedFolderLayoutStyle): void {
    this.quitAppCallback(folderStyle);
  }

  public registerBuildAppMenu(callback: (menu: MenuInfoType) => MenuInfo[]): void {
    this.buildMenuCall = callback;
  }

  public buildAppMenu(menu: MenuInfoType): MenuInfo[] {
    let menuInfoList: MenuInfo[] = [];
    try {
      menuInfoList = this.buildMenuCall?.(menu) ?? [];
    } catch (error) {
      log.error('build app menu error %{public}s', error?.message);
    }
    return menuInfoList;
  }

  /**
   * 执行文件夹解散回调
   *
   * @param folderId 文件夹id
   * @param disappearData 解散的数据
   */
  public disbandFolder(msg: string, folderId: string, flags: number = FolderOperationFlag.NONE): void {
    let uninstaller: IContractedFolderUninstallViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.UNINSTALL) as IContractedFolderUninstallViewModel;
    uninstaller?.notifyDisbandFolder(msg, folderId, flags);
  }

  /**
   * 移除未安装应用或快捷方式
   *
   * @param deleteItem 待移除应用
   */
  public removeItem(deleteItem: GridLayoutItemInfo, openFolderId: string): void {
    const uninstaller: IContractedFolderUninstallViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.UNINSTALL) as IContractedFolderUninstallViewModel;
    uninstaller?.uninstallItem('remove shortcut in folder', openFolderId, deleteItem, true);
  }

  /**
   * 放置文件夹菜单消失后执行的回调
   *
   * @param callBack
   */
  public pushFolderMenuDisAppearAnimation(callBack: () => void): void {
    this.mWaitFolderMenuDisappearCall.push(callBack);
  }

  /**
   * 执行已注册的文件夹菜单消失回调
   */
  public execFolderMenuDisappearCall(): void {
    try {
      this.mWaitFolderMenuDisappearCall.forEach((callback) => {
        callback();
      });
    } catch (error) {
      log.error('execute callback error after folder disappear', error);
    }
    this.mWaitFolderMenuDisappearCall = [];
  }

  /**
   * 关闭菜单
   */
  public closeMenu(folderId: string): void {
    let eventMgr: IContractedFolderEventViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.EVENT) as IContractedFolderEventViewModel;
    eventMgr?.onMenuClose('close menu', folderId);
  }

  /**
   * 打开文件夹
   *
   * @param msg 用于DFX日志打印
   * @param folderId 文件夹id
   * @param isRename 是否进入命名状态
   */
  public openFolder(msg: string, folderId: string, isRename: boolean, flags: number = FolderOperationFlag.NONE): void {
    let openCloser: IContractedFolderOpenCloseViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.OPEN_CLOSE) as IContractedFolderOpenCloseViewModel;
    openCloser?.open(msg, folderId, isRename, flags);
  }

  /**
   * 开始关闭文件夹
   *
   * @param msg 用于DFX的日志打印
   * @param flags 标识关闭文件夹的模式
   */
  public closeFolder(msg: string, flags: number = FolderOperationFlag.NONE): void {
    let openCloser: IContractedFolderOpenCloseViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.OPEN_CLOSE) as IContractedFolderOpenCloseViewModel;
    openCloser?.close(msg, flags);
  }

  /**
   * 开始关闭文件夹,并在文件夹关闭后执行指定回调
   *
   * @param msg 用于DFX的日志打印
   * @param callBack 关闭后执行的回调
   * @param flags 标识关闭文件夹的模式
   * @param isKeepPageIndex 是否重置当前页数
   */
  public closeFolderWithCallback(msg: string, callBack: () => void, flags: number = FolderOperationFlag.NONE): void {
    let openCloser: IContractedFolderOpenCloseViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.OPEN_CLOSE) as IContractedFolderOpenCloseViewModel;
    openCloser?.setClosedCallBack(callBack);
    openCloser?.close(msg, flags);
  }

  /**
   * 文件夹拖出应用后落位
   *
   * @param msg 用于DFX的日志
   * @param folderId 文件夹id
   * @param type 落位类型
   * @param param 落位参数
   */
  public drop(msg: string, folderId: string, type: FolderDropType, param: FolderDragItem): void {
    let dragVm: IContractedFolderDragViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.DRAG) as IContractedFolderDragViewModel;
    dragVm?.drop(msg, folderId, type, param);
  }

  /**
   * 生成文件夹的名字
   *
   * @param msg 用于DFX的日志打印
   * @returns 生成的文件夹名字
   */
  public generateFolderName(msg: string, endLayoutInfo: GridLayoutItemInfo,
    dragItems: GridLayoutItemInfo[] | DockItemInfo[]): string {
    let renameVm: IContractedFolderRenameViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.RENAME) as IContractedFolderRenameViewModel;
    return renameVm?.generateFolderName(msg, endLayoutInfo, dragItems);
  }

  /**
   * 更新文件夹名字
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param folderName 文件夹名字
   */
  public updateFolderName(msg: string, folderId: string, folderName: string): void {
    let renameVm: IContractedFolderRenameViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.RENAME) as IContractedFolderRenameViewModel;
    renameVm?.updateFolderName(msg, folderId, folderName);
  }

  /**
   * 创建一个文件夹
   *
   * @param msg 用于DFX日志定位
   * @param endItem 用于合成文件夹的元素
   * @param startItem 用于合成文件夹的元素
   * @returns 创建的文件夹对象
   */
  public createNewFolder(msg: string, endItem: GridLayoutItemInfo, startItem: GridLayoutItemInfo[]): GridLayoutItemInfo {
    let dragVm: IContractedFolderDragViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.DRAG) as IContractedFolderDragViewModel;
    return dragVm?.createNewFolder(msg, endItem, startItem);
  }

  /**
   * 拖拽覆盖元素
   *
   * @param msg 用于DFX日志打印
   * @param folderId 文件夹id
   * @param isShow 是否显示
   */
  public dragCover(msg: string, folderId: string, isShow: boolean): void {
    let dragVm: IContractedFolderDragViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.DRAG) as IContractedFolderDragViewModel;
    dragVm?.onFolderCovered(msg, folderId, isShow);
  }

  /**
   * 展开态拖拽应用离开文件夹
   *
   * @param msg 用于DFX的日志
   * @param folderId 文件夹id
   * @param dragItemInfo 拖拽的元素
   */
  public dragLeave(msg: string, folderId: string, dragItem: GridLayoutItemInfo): void {
    let dragVm: IContractedFolderDragViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.DRAG) as IContractedFolderDragViewModel;
    dragVm?.dragLeave(msg, folderId, dragItem);
  }

  /**
   * 执行业务传入回调
   *
   * @param callback 回调
   * @returns
   */
  public waitFolderAnimateFinish(callback: Callback<void>): void {
    try {
      callback();
    } catch (error) {
      log.error('waitFolderAnimateFinish: callback error', error);
    }
  }
}