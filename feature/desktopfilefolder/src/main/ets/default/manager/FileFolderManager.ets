/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import { DesktopFileInfo, FileType, GridLayoutItemInfo, MenuInfo } from '@ohos/launchercommon';
import { RightMenuNewFileData } from '../common/bean/RightMenuNewFileData';
import UDC from '@ohos.data.unifiedDataChannel';
import { BusinessError } from '@ohos.base';
import { DragGridPosition } from '@ohos/componentdrag';
import { SingleBase, SingleContext } from '@ohos/basicutils';
import context from '@ohos.app.ability.common';
import { FileFolderInfo } from '../model/FileFolderInfo';

export interface RefreshUriListener {
  onRefreshUri: (uri: string) => void;
}

export interface FileExistResult {
  isExist: boolean;
  existFileIno?: string;
}

export default abstract class FileFolderManager extends SingleBase {

  public static singleName: string = 'FileFolderManager';

  constructor(ctx?: SingleContext) {
    super(ctx);
  }

  /**
   * 重命名文件
   * @param uri 文件uri
   * @param name 文件名
   * @param isShowSuffix 是否处于显示后缀名状态
   * @returns
   */
  abstract rename(uri: string, name: string, isShowSuffix?: boolean): Promise<string>;

  /**
   * 重命名，不检查重名不提供撤销选项
   * @param srcUri 源文件uri
   * @param fileName 新文件吗
   * @returns 重名名后的新uri
   */
  abstract renameNoCheckNoHistory(srcUri: string, fileName: string): Promise<string>;

  /**
   * 打开桌面文件或文件夹
   * @param uri 文件uri
   * @param context context
   * @returns
   */
  abstract openFileOrFolder(uri: string, context?: context.UIAbilityContext): Promise<void>;

  /**
   * 获取文件位置，优先选择提供的位置，提供位置被占位，再在当前屏幕内查找
   * @param column
   * @param row
   * @param page
   * @returns
   */
  abstract getFileFolderPosition(column?: number, row?: number, page?: number): DragGridPosition | null;

  /**
   * 删除文件或文件夹
   * @param uris 待删除文件uri列表
   * @param isForceDelete 是否强制删除
   * @param isRegisterHistory 是否注册到文管可撤销操作中
   * @returns
   */
  abstract deleteFileOrFolder(uris: string[], isForceDelete?: boolean, isRegisterHistory?: boolean): Promise<void>;

  /**
   * dock注册回收站监听
   * @returns
   */
  abstract registerRecycleBinListenerFileAccess(): void;

  /**
   * 剪切文件
   * @param uris 待剪切文件列表
   */
  abstract cutFiles(uris: string[]): void;

  /**
   * 清空剪切板
   */
  abstract clearPasteboard(): void;

  /**
   * 复制文件
   * @param uris 待复制文件列表
   */
  abstract copyFiles(uris: string[]);

  /**
   * 粘贴文件
   * @returns
   */
  abstract pasteFiles(destUri?: string): Promise<void>;

  /**
   * 粘贴快捷方式
   * @param destinationUri
   * @returns
   */
  abstract pasteShortcut(destinationUri?: string): Promise<void>;

  /**
   * 从文件系统获取桌面路径文件后刷新桌面文件
   * @returns
   */
  abstract refreshDesktopFiles(): Promise<void>;

  /**
   * 新建文件夹
   * @param callback 新建结果回调
   * @param isRegisterHistory 是否注册到文管可撤销操作中
   * @returns
   */
  abstract createNewFolder(uri?: string, isRegisterHistory?: boolean): Promise<string | BusinessError<void>>;

  /**
   * 新建文件夹，给定行列数
   */
  abstract createNewFile(uris: Map<string, number[]>): void;

  /**
   * 通过uri获取文件信息
   * @param uri
   * @returns
   */
  abstract getFileInfoByUri(uri?: string): FileFolderInfo | undefined;

  /**
   * 当前是否支持文件特性
   * @returns true 支持，false: 不支持
   */
  abstract isSupportDesktopFile(): boolean;

  /**
   * 是否首次加载桌面文件
   * @returns
   */
  abstract isFilesFirstLoaded(): boolean;

  /**
   * 加载桌面文件
   */
  abstract tryToLoadDesktopFiles(reason: string): Promise<void>;

  /**
   * 注册文件图标刷新监听
   * @param ino 文件ino
   * @param listener 监听器
   */
  abstract registerRefreshUri(ino: string, listener: RefreshUriListener): void;

  /**
   * 解注册文件图标刷新监听
   * @param ino 文件ino
   */
  abstract unregisterRefreshUri(ino: string): void;

  /**
   * 获取默认文件图标
   * @param isFolder 是否文件夹
   * @returns 图标资源
   */
  abstract getDefaultImage(isFolder: boolean, fileName: string): Resource;

  /**
   * 获取文件后缀
   * @param fileName 文件名
   * @param isFolder 是否是文件夹
   * @returns 返回文件后缀
   */
  abstract getFileExtension(fileName: string | undefined, isFolder: boolean): string;

  /**
   * 获取DLP小锁图标资源
   * @returns
   */
  abstract getDlpImage(): Resource;

  /**
   * 查询右键菜单项列表
   * @param currentFile 菜单所在文件
   * @param selectFiles 所有被选中的文件
   * @returns 菜单项列表
   */
  abstract getRightMenuInfo(currentFile: string | undefined, selectFiles: string[], page: number): MenuInfo[];

  /**
   * 查询文件右键菜单“更多”子菜单项列表
   * @returns
   */
  abstract getMoreSubMenu(): MenuInfo[];

  /**
   * 查询文件右键菜单子菜单项列表（压缩，打开方式，更多）
   * @returns
   */
  abstract getAllSubMenu(fileUri: string | undefined): Map<string, MenuInfo[]>;
  /**
   * 查询文件右键菜单‘移入智慧文件夹’子菜单项列表
   * @returns
   */
  abstract getSmartFolderSubMenu(): MenuInfo[];

  abstract getUtdTypeByFileName(fileName: string): string;
  /**
   * 获取右键菜单最小宽度值，菜单可变宽度以支持较长文字菜单项
   * @returns 最小宽度值
   */
  abstract getRightMenuMinWidth(): number;

  /**
   * 构建默认新建文件菜单项
   * @param subMenuInfo
   */
  abstract pushDefaultBlankFile(subMenuInfo: MenuInfo[]);

  /**
   * 构建分区文件夹默认新建文件菜单项
   * @param subMenuInfo
   */
  abstract pushDefaultBlankFileAtRegionFolder(subMenuInfo: MenuInfo[]): void;

  /**
   * 外部拖拽文件到桌面
   * @param event 拖拽事件
   * @returns
   */
  abstract dropFileToDesktop(event: DragEvent, extraParams?: string, extraData?: string): Promise<void>;

  /**
   * 外部拖拽文件到大文件夹
   * @param event 拖拽事件
   * @returns
   */
  abstract dropFileToRegionFolder(event: DragEvent, destUri: string, extraParams?: string,
    extraData?: string): Promise<void>;

  /**
   * 拖拽文件到指定文件夹
   * @param event 拖拽事件
   * @param targetUri 指定文件夹uri
   * @returns
   */
  abstract dropFile(event: DragEvent, targetUri: string, extraParams?: string, extraData?: string,
    isContainApp?: boolean): Promise<void>;
  /**
   * 外部拖拽文件进入桌面的处理
   * @param event 拖拽事件
   * @returns
   */
  abstract fileFolderEnterDesktop(event: DragEvent ): void;

  /**
   * 获取拖拽文件的ino
   * @param event 拖拽事件
   * @returns
   */
  abstract getFileInos(event: DragEvent): Promise<Array<string>>;

  /**
   * 桌面文件起拖时放入信息
   * @param event 拖拽事件
   * @param dragInfos 拖拽文件信息
   * @returns
   */
  abstract getDragEventData(dragInfos: Array<GridLayoutItemInfo>): UDC.UnifiedData;

  /**
   * dock注册回收站监听
   * @param callback 回收站发生变化时dock的回调
   */
  abstract registerRecycleBinListener(screenId: number, callback: Function): void;

  /**
   * dock注销回收站监听
   */
  abstract unRegisterRecycleBinListener(screenId: number): void;

  /**
   * dock刷新回收站图标
   * @param callback 回收站发生变化时dock的回调
   */
  abstract refreshRecycleBinIconState(callback?: Function): void;

  /**
   * 获取文件夹图标资源
   */
  abstract getFolderIconResource(): Resource;

  /**
   * 获取文件统一图标资源
   * @returns
   */
  abstract getFileIconResource(fileName: string): PixelMap | string | Resource | null;

  /**
   * 桌面撤销
   */
  abstract doRevoke(): void;

  /**
   * 判断是否能撤销
   */
  abstract canUndo(): boolean;

  /**
   * 获取右键菜单-撤销内容
   */
  abstract getUndoText(): string;

  /**
   * 桌面反撤销
   */
  abstract doReverseRevoke(): void;

  /**
   * 判断是否能反撤销
   */
  abstract canRedo(): boolean;

  /**
   * 获取右键菜单-反撤销内容
   */
  abstract getRedoText(): string;

  /**
   * 打开文件详情
   */
  abstract openFileDetail(fileUri: string[], isClickFolder?: boolean): void;


  /**
   * 打开文件预览
   */
  abstract openFilePreview(fileUri: string | undefined): void;

  /**
   * 传入鼠标右键坐标
   */
  abstract setRightClickPosition(windowX: number, windowY: number): void;

  /**
   * 设置桌面菜单状态
   */
  abstract setMenuShowStatus(isMenuShow: boolean): void;

  /**
   * 获取桌面菜单状态
   */
  abstract getMenuShowStatus(): boolean;

  /**
   * 设置拖拽到pc桌面的文件文件夹角标（剪切或者复制）
   */
  abstract setFileFolderBadge(event: DragEvent, extraParams?: string): void;

  /**
   * 通过文件uri以及文件大小获取文件hover详细信息
   */
  abstract getFileSummaryByUri(uri: string | undefined, size?: number): string[];

  /**
   * 通过文件夹uri获取文件夹大小
   * @param uri
   * @returns
   */
  abstract getFolderSizeByUri(uri: string): Promise<number>;

  /**
   * super fold 折叠态，右键粘贴文件需要复制到对应page
   * @param page
   * @returns
   */
  abstract pasteFileToFixedPage(page: number, isShortCut: boolean): Promise<void>;

  /**
   * 判断文件是否是Video类型
   * @returns
   */
  abstract isVideoThumbnailType(uri?: string): boolean;

  /**
   * 右键菜单创建智慧文件夹
   */
  abstract createSmartNewFolder(): void;


  /**
   * 文件替换显示名称
   * @param uri 文件uri
   * @returns 最终显示名称
   */
  abstract getGuiNameByFileInfo(uri?: string): string;

  /**
   * 菜单中文字资源跟随系统语言变化
   */
  abstract languageChangeRefresh(): void;

  abstract moveFile(srcUri: string, destUri: string): Promise<string>;

  abstract moveFileToDesktop(srcUri: string): Promise<string>;

  abstract isFileFolderExist(fileName: string, fileType: number, targetUri?: string): FileExistResult;

  abstract listFilesOfFolder(uri: string, callback: Function): void;

  abstract registerFolderChange(uri: string, callback: () => void): void;

  abstract unregisterFolderChange(uri: string): void;

  abstract deleteFileOrFolderByName(fileName: string): void;

  abstract getFolderUriByName(fileName: string, targetUri?: string): string;

  /**
   * 通知文管刷新，否则大批量移动文件文管UI会在3s后刷新
   * @param folderUris
   * @param includeDesktop 除了folderUris外是否也要刷新桌面uri
   */
  abstract notifyFoldersRefresh(folderUris: string[], includeDesktop?: boolean): void;

  /**
   * 获取快捷方式目标文件的uri
   */
  abstract getShortCutTargetUri(uri: string | undefined): string;

  /**
   * 获取创建快捷方式菜单项
   * @returns
   */
  abstract getCreateShortcutMenu(): MenuInfo;

  /**
   * 获取粘贴快捷方式菜单
   * @returns
   */
  abstract getPasteShortcutMenu(): MenuInfo;

  /**
   * 新建文件快捷方式
   */
  abstract createShortCutFile(column: number, row: number, page: number, uri?: string): void;

  /**
   * 是否为快捷方式
   * @returns
   */
  abstract isShortcutFile(fileFolderInfo: GridLayoutItemInfo): boolean;
  /**
   * 获取快捷方式源文件的信息
   * @param uri 快捷方式的uri
   * @returns 快捷方式指向文件的文件信息
   */
  abstract getTargetInfoByShortcutUri(uri: string | undefined): FileFolderInfo | undefined;

  /**
   * 获取快捷方式映射对象的文件类型
   * @returns
   */
  abstract getShortcutTargetFileType(fileFolderInfo: GridLayoutItemInfo): FileType | undefined;

  /**
   * 存储uri到桌面位置的映射
   * @param uris uri路径
   * @param column 列
   * @param row 行
   * @param page 页
   */
  abstract setDesktopPositionByUris(uris: string[], column: number, row: number, page: number): void

  /**
   * 判断是否来自于文管'快速访问'区域的拖拽
   */
  abstract isDragFromSideBar(extraInfo?: string): boolean

  /**
   * 获取二级菜单
   * @param menuKey 一级菜单key
   * @param fileUri
   * @returns
   */
  abstract getSecondaryMenuInfo(menuKey: string, fileUri: string): MenuInfo[];

  /**
   * 获取文件文件夹hover tips的可用高度
   * @returns
   */
  abstract getTipsAvailableHeight(): number


  /**
   * 获取textArea输入框的可用高度
   * @param textAreaTop textArea的top值,单位vp
   * @param screenId textArea对应的屏幕id
   * @returns
   */
  abstract getTextAreaAvailableHeight(textAreaTop: number, screenId?: number): number

  /**
   * 是否显示桌面右键的'粘贴为快捷方式'菜单项,异步接口
   * @returns
   */
  abstract isShowPasteShortcutMenu(): Promise<boolean>

  /**
   * 注册PC收纳夹路径文件变更监听
   * @param uri
   * @param callback
   * @returns
   */
  abstract registerRegionFolderFileChange(uri: string, callback: Function): void

  /**
   * 解注册PC收纳夹路径文件变更监听
   * @param uri
   * @param callback
   * @returns
   */
  abstract unregisterRegionFolderFileChange(uri: string, callback: Function): void
}

export enum FileSuffix {
  H_LINK = 'hlink',
}
