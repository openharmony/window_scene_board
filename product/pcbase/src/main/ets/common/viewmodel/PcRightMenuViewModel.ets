/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { PageDesktopViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/PageDesktopViewModel';
import fileFolderManagerFactory from '@ohos/desktopfilefolder/src/main/ets/default/manager/FileFolderManagerFactory';
import FileFolderManager from '@ohos/desktopfilefolder/src/main/ets/default/manager/FileFolderManager';
import {
  FormCenterViewManager,
  KeyEventConstants,
  keyEventManager,
  EventConstants,
  KeyEventListener
} from '@ohos/launchercommon';
import { Prompt, promptAction } from '@kit.ArkUI';

import { RightMenuViewModel } from '@ohos/launchercommon/src/main/ets/pagedesktop/viewmodel/RightMenuViewModel';
import { MenuInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { LogDomain, LogHelper, SingleContext, } from '@ohos/basicutils';
import {
  DeviceHelper,
  HiSysEventUtil,
  localEventManager,
  ResourceManager,
  SystemParamUtils
} from '@ohos/frameworkwrapper';
import { ExtAppConstants } from '@ohos/commonconstants';
import { DisplayConstants, StartAbilityUtil } from '@ohos/windowscene';
import { pasteboard } from '@kit.BasicServicesKit';
import measure from '@ohos.measure';
import { DesktopSortRule, DesktopSortInfo } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { DragGridPosition } from '@ohos/componentdrag';
import { FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import display from '@ohos.display';
import RightMenuOptionsCalc from './RightMenuOptionsCalc';
import { PCUtils } from '../utils/PCUtils';
import { MenuPreHandlerModel } from '@ohos/desktopfilefolder';

const TAG = 'PcRightMenuViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const CLICK_DELAY: number = 300;
const DEFAULT_MENU_ITEM_SIDE_PADDING: number = 19;
const DEFAULT_FONT_SIZE: number = 16;
const DEFAULT_MENU_PLACEHOLDER_TEXT: string = 's%';
const DEFAULT_MENU_CREATE_PADDING: number = 32;
const DEFAULT_END_ICON_PADDING: number = 24;
const DEFAULT_SCREEN_ID = 0;

export default class PcRightMenuViewModel extends RightMenuViewModel {
  public static singleName: string = 'PcRightMenuViewModel';
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
  private fileFolderManager: FileFolderManager = fileFolderManagerFactory.getFileFolderManager();
  private systemPasteBoard?: pasteboard.SystemPasteboard;
  private isClicked: boolean = false;
  private desktopSortRule: DesktopSortRule = DesktopSortRule.SORT_NONE;
  private isAscend: boolean = true;
  private rightMenuOptionsCalc?: RightMenuOptionsCalc;
  private screenId: number = DEFAULT_SCREEN_ID;
  private menuPreHandlerModel: MenuPreHandlerModel = new MenuPreHandlerModel();

  public constructor(ctx?: SingleContext) {
    super(ctx);
    this.screenId = ctx?.extendScreenId ?? DEFAULT_SCREEN_ID;
    log.showInfo(`MINGFAN PcRightMenuViewModel :${this.screenId}`);
  }

  public setRightMenuOptionsCalc(rightMenuOptionsCalc: RightMenuOptionsCalc): void {
    this.rightMenuOptionsCalc = rightMenuOptionsCalc;
  }

  public async rightMenuShowPreHandler(): Promise<void> {
    this.menuPreHandlerModel.init();
    this.fileFolderManager.isShowPasteShortcutMenu().then((isShowPasteShortcut)=> {
      this.menuPreHandlerModel.setIsShowPasteShortcutMenu(isShowPasteShortcut);
    });
    log.showInfo(`rightMenuShowPreHandler menuPreHandlerModel: ${this.menuPreHandlerModel.toString()}`);
  }

  /**
   * 获取右键菜单列表，包含页面构建和响应事件
   * @returns 右键菜单列表
   */
  public getRightMenuInfoList(): MenuInfo[] {
    let menuInfoList: MenuInfo[] = [];
    if (this.screenId !== 0) {
      if (!SystemParamUtils.isHddProduct() && !DeviceHelper.isEmulator()) {
        menuInfoList.push(this.getIndividuationMenu());
        menuInfoList.push(this.getEditWallPaperMenuInfo());
      }
      menuInfoList.push(this.getDisplayMenu());
      return menuInfoList;
    }
    menuInfoList.push(this.getNewFileMenu());
    menuInfoList.push(this.getSeparatorItem(MenuConstants.KEY_DIVIDER_CREATE));
    menuInfoList.push(this.getTrimMenu());
    menuInfoList.push(this.getDesktopSortMenu());
    menuInfoList.push(this.getSeparatorItem(MenuConstants.KEY_DIVIDER_SORT));
    if (!SystemParamUtils.isHddProduct() && !DeviceHelper.isEmulator()) {
      menuInfoList.push(this.getIndividuationMenu());
      menuInfoList.push(this.getEditWallPaperMenuInfo());
    }
    menuInfoList.push(this.getDisplayMenu());
    menuInfoList.push(this.getFormCenterMenu());
    if (this.checkIfPasteNeeded()) {
      menuInfoList.push(this.getPasteMenu());
    }
    if (this.menuPreHandlerModel.isShowPasteShortcutMenu) {
      menuInfoList.push(this.getPasteShortCutMenu());
    }
    if (this.fileFolderManager.canUndo()) {
      menuInfoList.push(this.getUndoMenu());
    }
    if (this.fileFolderManager.canRedo()) {
      menuInfoList.push(this.getRedoMenu());
    }
    menuInfoList.push(this.getSeparatorItem(MenuConstants.KEY_DIVIDER_COLLABORATION));
    menuInfoList.push(this.getCollaborationMenu());
    return menuInfoList;
  }

  /**
   * 获取右键菜单自适应宽度
   * @param menuItem 菜单项信息
   * @returns 适应文字的菜单宽度
   */
  public getMenuWidthAdaptive(menuItem: MenuInfo): number {
    let menuWidth: number = this.getMeasureOptions(menuItem);
    const placeholderWidth: number = this.measureTextWidth(DEFAULT_MENU_PLACEHOLDER_TEXT);
    log.showInfo(`measure menuWidth before ${menuWidth} placeholderWidth ${placeholderWidth} `);
    if (menuItem.menuKeyString === MenuConstants.KEY_UNDO) {
      menuWidth = menuWidth - placeholderWidth +
      this.measureTextWidth(this.fileFolderManager.getUndoText()) +
      this.measureTextWidth(menuItem.shortcutKeyTips ?? '');
    }
    if (menuItem.menuKeyString === MenuConstants.KEY_REDO) {
      menuWidth = menuWidth - placeholderWidth +
      this.measureTextWidth(this.fileFolderManager.getRedoText()) +
      this.measureTextWidth(menuItem.shortcutKeyTips ?? '');
    }
    if (menuItem.menuKeyString === MenuConstants.KEY_CREATE_FILE) {
      menuWidth = menuWidth + this.measureTextWidth(menuItem.shortcutKeyTips ?? '') + DEFAULT_MENU_CREATE_PADDING;
    }
    if (menuItem.menuKeyString === MenuConstants.KEY_COLLABORATION) {
      menuWidth = menuWidth + DEFAULT_END_ICON_PADDING;
    }
    log.showInfo(`measure menuWidth after ${menuWidth}`);
    return menuWidth + DEFAULT_MENU_ITEM_SIDE_PADDING * 2;
  }

  /**
   * 计算菜单资源文本宽度
   * @param menuItem
   * @returns
   */
  private getMeasureOptions(menuItem: MenuInfo): number {
    return Math.ceil(px2vp(measure.measureText({
      textContent: menuItem.menuText,
      fontSize: DEFAULT_FONT_SIZE,
      fontWeight: 'medium',
    })));
  }

  /**
   * 计算文本宽度
   * @param text
   * @returns
   */
  private measureTextWidth(text: string): number {
    return Math.ceil(px2vp(measure.measureText({
      textContent: text,
      fontSize: DEFAULT_FONT_SIZE,
      fontWeight: 'medium',
    })));
  }

  /**
   * 右键菜单注册按键事件监听
   * 按键U,响应撤销
   * 按键R,响应恢复
   */
  public registerKeyEvent(): void {
    log.showInfo('right menu registerKeyEvent');
    keyEventManager.registerKeyEventListener(this.mKeyEventListener, [
      KeyEventConstants.EVENT_U,
      KeyEventConstants.EVENT_R,
    ]);
  }

  /**
   * 右键菜单取消注册按键事件监听
   */
  public unRegisterKeyEvent(): void {
    log.showInfo('right menu unRegisterKeyEvent');
    keyEventManager.unRegisterKeyEventListener(this.mKeyEventListener);
  }

  private readonly mKeyEventListener: KeyEventListener = {
    onReceiveKeyEvent: (event: string): void => {
      log.showInfo('right menu key event come: ' + event);
      switch (event) {
        case KeyEventConstants.EVENT_U:
          if (this.fileFolderManager.canUndo()) {
            this.mPageDesktopViewModel.doRevoke();
            ContextMenu.close();
          }
          break;
        case KeyEventConstants.EVENT_R:
          if (this.fileFolderManager.canRedo()) {
            this.mPageDesktopViewModel.doReverseRevoke();
            ContextMenu.close();
          }
          break;
        default:
          break;
      }
    }
  };

  private getSeparatorItem(bundleName: string = ''): MenuInfo {
    let cMenuInfo: MenuInfo = new MenuInfo();
    cMenuInfo.menuKeyString = '-';
    cMenuInfo.bundleName = bundleName;
    return cMenuInfo;
  }

  private checkIfPasteNeeded(): boolean {
    this.systemPasteBoard = pasteboard.getSystemPasteboard();
    try {
      if (this.systemPasteBoard && this.systemPasteBoard.hasDataType(pasteboard.MIMETYPE_TEXT_URI)) {
        return true;
      } else {
        log.showInfo('checkIfPasteNeeded, there are not uri data exists on pasteboard');
        return false;
      }
    } catch (err) {
      log.showError(`checkIfPasteNeeded pasteboard getData error. Cause:${err?.message}`);
      return false;
    }
  }

  private getIndividuationMenu(): MenuInfo {
    let themeEditor: MenuInfo = new MenuInfo();
    themeEditor.menuText = $r('app.string.individuation');
    themeEditor.menuKeyString = MenuConstants.KEY_THEME;
    themeEditor.bundleName = MenuConstants.BUNDLE_NAME_CREATE_INDIVIDUATION;
    themeEditor.onMenuClick = (): void => {
      log.showInfo('individuation start');
      HiSysEventUtil.reportDesktopRightMenuIndividuation();
      this.startIndividuationMainAbility();
    };
    return themeEditor;
  }

  private getEditWallPaperMenuInfo(): MenuInfo {
    let themeEditor: MenuInfo = new MenuInfo();
    themeEditor.menuText = $r('app.string.edit_wall_paper');
    themeEditor.menuKeyString = MenuConstants.KEY_WALL_PAPER;
    themeEditor.bundleName = MenuConstants.BUNDLE_NAME_CREATE_EDIT_WALL_PAPER;
    themeEditor.onMenuClick = (): void => {
      log.showInfo('edit_wall_paper start');
      HiSysEventUtil.reportDesktopRightMenu(MenuConstants.REPORT_CREATE_EDIT_WALL_PAPER);
      this.gotoEditWallPaperPage();
    };
    return themeEditor;
  }

  private getDisplayMenu(): MenuInfo {
    let display: MenuInfo = new MenuInfo();
    display.menuText = $r('app.string.display_settings_title');
    display.menuKeyString = MenuConstants.KEY_DISPLAY;
    display.onMenuClick = (): void => {
      log.showInfo('display start');
      HiSysEventUtil.reportDesktopRightMenu(MenuConstants.REPORT_DISPLAY_SETTINGS);
      StartAbilityUtil.startAbilityFromOther({
        bundleName: ExtAppConstants.PKG_PC_SETTINGS,
        abilityName: ExtAppConstants.ABILITY_SETTINGS_MAIN,
        uri: MenuConstants.MENU_URI_DISPLAY_SETTINGS,
        moduleName: DeviceHelper.is2In1DevicePcType() ? MenuConstants.MENU_PHONE_SETTINGS
          : MenuConstants.MENU_PC_SETTINGS,
        parameters: {
          screenId: this.screenId
        }
      });
    };
    return display;
  }

  private getNewFileMenu(): MenuInfo {
    let createMenu = new MenuInfo();
    createMenu.menuText = $r('app.string.right_create');
    createMenu.menuKeyString = MenuConstants.KEY_CREATE;
    createMenu.bundleName = 'create';
    let subMenuInfo: MenuInfo[] = [];
    let createSubFolder = new MenuInfo();
    createSubFolder.bundleName = MenuConstants.BUNDLE_NAME_CREATE_FOLDER;
    createSubFolder.menuText = $r('app.string.right_create_folder');
    createSubFolder.menuKeyString = MenuConstants.KEY_CREATE_FILE;
    createSubFolder.menuImgSrc = $r('app.media.ic_normal_folder_empty_');
    createSubFolder.shortcutKeyTips = 'Ctrl+Shift+N';
    createSubFolder.onMenuClick = (column?: number, row?: number, pageId?: number): void => {
      if (this.isClicked) {
        return;
      }
      this.isClicked = true;
      const filePosition = this.fileFolderManager.getFileFolderPosition(column, row, pageId);
      if (!filePosition) {
        HiSysEventUtil.reportFullContinueAdding(DisplayConstants.DEFAULT_DISPLAY);
        Prompt.showToast({
          message: ResourceManager.getInstance().getStringByName('add_icon_to_desktop_max'),
          bottom: this.mPageDesktopViewModel.getToastBottom()
        });
        this.isClicked = false;
        return;
      }
      const newFolderColumn = filePosition.column;
      const newFolderRow = filePosition.row;
      this.fileFolderManager.createNewFolder().then(dirUri => {
        if (dirUri instanceof Error) {
          log.error('create new folder failed. err:', dirUri);
          return;
        }
        log.showInfo(`createNemFolder success.Column: ${newFolderColumn} Row: ${newFolderRow}`);
        AppStorage.setOrCreate<string>('newCreateFolder', dirUri);

        let uris: Map<string, number[]> = new Map<string, number[]>();
        let colAndRow: number[] = filePosition.page === undefined ?
          [newFolderColumn, newFolderRow] : [newFolderColumn, newFolderRow, filePosition.page];
        uris.set(dirUri, colAndRow);
        this.fileFolderManager.createNewFile(uris);
        this.fileFolderManager.refreshDesktopFiles();
      });
      log.showInfo('create folder end');
      setTimeout(() => {
        this.isClicked = false;
      }, CLICK_DELAY);
    };
    subMenuInfo.push(createSubFolder);
    subMenuInfo.push(this.fileFolderManager.getCreateShortcutMenu());
    subMenuInfo.push(this.getSeparatorItem(MenuConstants.KEY_DIVIDER_CREATE_SHORTCUT));
    this.fileFolderManager.pushDefaultBlankFile(subMenuInfo);
    createMenu.subMenuList = subMenuInfo;
    return createMenu;
  }

  private getCollaborationMenu(): MenuInfo {
    let collMenu = new MenuInfo();
    collMenu.menuText = $r('app.string.right_collaboration');
    collMenu.menuKeyString = MenuConstants.KEY_COLLABORATION;
    collMenu.bundleName = MenuConstants.BUNDLE_NAME_COLLABORATION;
    return collMenu;
  }

  private getTrimMenu(): MenuInfo {
    let trimMenu: MenuInfo = new MenuInfo();
    trimMenu.menuText = $r('app.string.desktop_auto_sort');
    trimMenu.bundleName = MenuConstants.BUNDLE_NAME_TRIM;
    trimMenu.menuKeyString = MenuConstants.KEY_TRIM;
    trimMenu.onMenuClick = (column?: number, row?: number, event?: ClickEvent, page?: number): void => {
      HiSysEventUtil.reportDesktopRightMenu(MenuConstants.REPORT_TRIM);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_DESKTOP_TRIM, page != null ? page : 0);
    };
    return trimMenu;
  }

  private getPasteMenu(): MenuInfo {
    let pasteFileFolder: MenuInfo = new MenuInfo();
    pasteFileFolder.menuText = $r('app.string.paste');
    pasteFileFolder.bundleName = MenuConstants.BUNDLE_NAME_PASTE;
    pasteFileFolder.menuKeyString = MenuConstants.KEY_PASTE;
    pasteFileFolder.shortcutKeyTips = 'Ctrl+V';
    pasteFileFolder.onMenuClick = (column?: number, row?: number, event?: ClickEvent, page?: number): void => {
      this.mPageDesktopViewModel.doPasteEvent();
      log.showInfo('onMenuClick paste file folder');
    };
    return pasteFileFolder;
  }

  private getPasteShortCutMenu(): MenuInfo {
    let pasteShortCut: MenuInfo = new MenuInfo();
    pasteShortCut.menuText = $r('app.string.paste_shortcut');
    pasteShortCut.onMenuClick = (column?: number, row?: number, event?: ClickEvent, page?: number): void => {
      this.fileFolderManager.pasteShortcut();
      log.showInfo('onMenuClick pasteShortcut');
    };
    return pasteShortCut;
  }

  private getFormCenterMenu(): MenuInfo {
    let formCenter: MenuInfo = new MenuInfo();
    formCenter.menuText = $r('app.string.edit_form_to_desktop');
    formCenter.menuKeyString = MenuConstants.KEY_FORM_CENTER;
    formCenter.bundleName = MenuConstants.BUNDLE_NAME_FORM_CENTER;
    formCenter.onMenuClick = (column?: number, row?: number, position?: Position): void => {
      HiSysEventUtil.reportDesktopRightMenuFormCenter();
      log.showInfo('onMenuClick formCenter');
      let param: FormCenterViewParam = new FormCenterViewParam();
      if (position) {
        param.entrancePosition = FormCenterViewManager.getInstance()
          .getEntrancePos(undefined, { x: position.x as number, y: position.y as number });
      }
      FormCenterViewManager.getInstance().openFormCenterView(param);
    };
    return formCenter;
  }

  private getUndoMenu(): MenuInfo {
    let undoMenu: MenuInfo = new MenuInfo();
    undoMenu.menuText = $r('app.string.undo_s', this.fileFolderManager.getUndoText());
    undoMenu.menuKeyString = MenuConstants.KEY_UNDO;
    undoMenu.bundleName = MenuConstants.BUNDLE_NAME_UNDO;
    undoMenu.shortcutKeyTips = 'Ctrl+Z';
    undoMenu.onMenuClick = (): void => {
      log.showInfo('onMenuClick undo');
      this.mPageDesktopViewModel.doRevoke();
    };
    return undoMenu;
  }

  private getRedoMenu(): MenuInfo {
    let redoMenu: MenuInfo = new MenuInfo();
    redoMenu.menuText = $r('app.string.redo_s', this.fileFolderManager.getRedoText());
    redoMenu.menuKeyString = MenuConstants.KEY_REDO;
    redoMenu.bundleName = MenuConstants.BUNDLE_NAME_REDO;
    redoMenu.shortcutKeyTips = 'Ctrl+Y';
    redoMenu.onMenuClick = (): void => {
      log.showInfo('onMenuClick redo');
      this.mPageDesktopViewModel.doReverseRevoke();
    };
    return redoMenu;
  }

  /**
   * 调起设置页的个性化页面
   *
   * @returns
   */
  public startIndividuationMainAbility(): void {
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
      uri: 'theme_settings',
      moduleName: 'phone',
      parameters: {
        screenId: this.screenId
      }
    });
  }

  /**
   * 调起设置页面个性化页面中的壁纸页面
   * @returns
   */
  public async gotoEditWallPaperPage(): Promise<void> {
    if (await PCUtils.isModifyWallpaperDisable()) {
      log.showInfo(`modify wallpaper is disbaled,show toast`);
      try {
        promptAction.showToast({
          message: $r('app.string.disable_modify_wallpaper_tips')
        });
      } catch (e) {
        log.showError(`showToast fail, code: ${e?.code}, message: ${e?.message}`);
      }
      return;
    }
    if (DeviceHelper.is2In1DevicePcType()) {
      StartAbilityUtil.startAbilityFromOther({
        bundleName: ExtAppConstants.PKG_PC_SETTINGS,
        abilityName: ExtAppConstants.ABILITY_SETTINGS_MAIN,
        uri: MenuConstants.MENU_URI_THEME_SETTINGS,
        moduleName: MenuConstants.MENU_PHONE_SETTINGS,
        parameters: {
          subUri: MenuConstants.MENU_PHONE_WALLPAPER,
          screenId: this.screenId
        }
      });
    } else {
      StartAbilityUtil.startAbilityFromOther({
        bundleName: ExtAppConstants.PKG_PC_SETTINGS,
        abilityName: ExtAppConstants.ABILITY_SETTINGS_MAIN,
        uri: MenuConstants.MENU_PC_WALLPAPER,
        moduleName: MenuConstants.MENU_PC_SETTINGS,
        parameters: {
          screenId: this.screenId
        }
      });
    }
  }

  /**
   * 设置桌面菜单状态
   */
  public setMenuShowStatus(isMenuShow: boolean): void {
    this.fileFolderManager.setMenuShowStatus(isMenuShow);
  }

  private getDesktopSortMenu(): MenuInfo {
    let createMenu = new MenuInfo();
    createMenu.menuText = $r('app.string.desktop_sort');
    createMenu.menuKeyString = MenuConstants.KEY_SORT;
    createMenu.bundleName = MenuConstants.BUNDLE_NAME_SORT;
    let subMenuInfo: MenuInfo[] = [];
    log.showInfo(`selecedSortRule is ${this.desktopSortRule}`);
    subMenuInfo.push(this.getSortSubMenu(DesktopSortRule.SORT_BY_NAME));
    subMenuInfo.push(this.getSortSubMenu(DesktopSortRule.SORT_BY_MODIFY_TIME));
    subMenuInfo.push(this.getSortSubMenu(DesktopSortRule.SORT_BY_CREATE_TIME));
    subMenuInfo.push(this.getSortSubMenu(DesktopSortRule.SORT_BY_SIZE));
    subMenuInfo.push(this.getSortSubMenu(DesktopSortRule.SORT_BY_TYPE));

    createMenu.subMenuList = subMenuInfo;
    return createMenu;
  }

  private getSortSubMenu(rule: DesktopSortRule): MenuInfo {
    let menu = new MenuInfo();
    switch (rule) {
      case DesktopSortRule.SORT_BY_NAME:
        menu.bundleName = MenuConstants.BUNDLE_NAME_SORT_BY_NAME;
        menu.menuText = $r('app.string.sort_by_name');
        menu.menuKeyString = MenuConstants.KEY_SORT_BY_NAME;
        break;
      case DesktopSortRule.SORT_BY_MODIFY_TIME:
        menu.bundleName = MenuConstants.BUNDLE_NAME_SORT_BY_MODIFY_TIME;
        menu.menuText = $r('app.string.sort_by_modify_time');
        menu.menuKeyString = MenuConstants.KEY_SORT_BY_MODIFY_TIME;
        break;
      case DesktopSortRule.SORT_BY_CREATE_TIME:
        menu.bundleName = MenuConstants.BUNDLE_NAME_SORT_BY_CREATE_TIME;
        menu.menuText = $r('app.string.sort_by_create_time');
        menu.menuKeyString = MenuConstants.KEY_SORT_BY_CREATE_TIME;
        break;
      case DesktopSortRule.SORT_BY_SIZE:
        menu.bundleName = MenuConstants.BUNDLE_NAME_SORT_BY_SIZE;
        menu.menuText = $r('app.string.sort_by_size');
        menu.menuKeyString = MenuConstants.KEY_SORT_BY_SIZE;
        break;
      case DesktopSortRule.SORT_BY_TYPE:
        menu.bundleName = MenuConstants.BUNDLE_NAME_SORT_BY_TYPE;
        menu.menuText = $r('app.string.sort_by_type');
        menu.menuKeyString = MenuConstants.KEY_SORT_BY_TYPE;
        break;
      default:
        break;
    }
    menu.onMenuClick = (column?: number, row?: number, page?: number): void => {
      if (this.desktopSortRule !== rule) {
        this.desktopSortRule = rule;
        this.isAscend = true;
      } else {
        this.isAscend = !this.isAscend;
      }
      let info: DesktopSortInfo = {
        sortRule: rule,
        isAscend: this.isAscend,
        page: page != null ? page : 0
      };
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_SORT, info);
      HiSysEventUtil.reportSortDesktop(0, rule, this.isAscend);
    };
    return menu;
  }

  /**
   * 获取桌面元素((文件文件夹、应用图标、卡片、桌面空白处))菜单方位
   * @param event  事件
   * @param menuInfoList 菜单列表
   * @param menuType 菜单类型
   * @returns
   */
  public getMenuPlacement(event: BaseEvent, menuInfoList: MenuInfo[], menuType: string): Placement | undefined {
    return this.rightMenuOptionsCalc?.getMenuPlacement(event, menuInfoList, menuType);
  }

  /**
   * 获取桌面元素(文件文件夹、应用图标、卡片、桌面空白处)菜单offset偏移量
   * @param event 事件
   * @param menuInfoList 菜单列表
   * @param menuType 菜单类型
   * @returns
   */
  public getMenuOffset(event: BaseEvent, menuInfoList: MenuInfo[], menuType: string): Position {
    if (!this.rightMenuOptionsCalc) {
      log.showError('getMenuOffset invalid rightMenuOptionsCalc');
      const position: Position = {
        x: 0,
        y: 0
      }
      return position;
    }
    return this.rightMenuOptionsCalc?.getMenuOffset(event, menuInfoList, menuType);
  }

  /**
   * 菜单中文字资源跟随系统语言变化
   * @returns
   */
  public languageChangeRefresh(): void {
    this.fileFolderManager.languageChangeRefresh();
  }
}

class MenuConstants {
  public static readonly KEY_CREATE: string = 'KEY_CREATE';
  public static readonly KEY_CREATE_FILE: string = 'KEY_CREATE_FILE';
  public static readonly KEY_CREATE_SMART_FILE: string = 'KEY_CREATE_SMART_FILE';
  public static readonly KEY_THEME: string = 'KEY_THEME';
  public static readonly KEY_WALL_PAPER: string = 'KEY_WALL_PAPER';
  public static readonly KEY_DISPLAY: string = 'KEY_DISPLAY';
  public static readonly KEY_PASTE: string = 'KEY_PASTE';
  public static readonly KEY_TRIM: string = 'KEY_TRIM';
  public static readonly KEY_FORM_CENTER: string = 'KEY_FORM_CENTER';
  public static readonly KEY_UNDO: string = 'KEY_UNDO';
  public static readonly KEY_REDO: string = 'KEY_REDO';
  public static readonly KEY_COLLABORATION: string = 'KEY_COLLABORATION';

  public static readonly BUNDLE_NAME_CREATE_FOLDER: string = 'createFolder';
  public static readonly BUNDLE_NAME_CREATE_SMART_FOLDER: string = 'createSmartFolder';
  public static readonly BUNDLE_NAME_PASTE: string = 'paste';
  public static readonly BUNDLE_NAME_TRIM: string = 'desktop_trim';
  public static readonly BUNDLE_NAME_CREATE_INDIVIDUATION: string = 'individuation';
  public static readonly BUNDLE_NAME_CREATE_EDIT_WALL_PAPER: string = 'edit_wall_paper';
  public static readonly BUNDLE_NAME_FORM_CENTER: string = 'formCenter';
  public static readonly BUNDLE_NAME_UNDO: string = 'undo';
  public static readonly BUNDLE_NAME_REDO: string = 'redo';
  public static readonly BUNDLE_NAME_COLLABORATION: string = 'collaboration';

  public static readonly MENU_URI_THEME_SETTINGS: string = 'theme_settings';
  public static readonly MENU_URI_DISPLAY_SETTINGS: string = 'display_settings';
  public static readonly MENU_PC_SETTINGS: string = 'phone';
  public static readonly MENU_PHONE_SETTINGS: string = 'phone_settings';
  public static readonly MENU_PC_WALLPAPER: string = 'theme_wallpaper';
  public static readonly MENU_PHONE_WALLPAPER: string = 'wallpaperPicker';

  public static readonly KEY_SORT: string = 'KEY_SORT';
  public static readonly KEY_SORT_BY_NAME: string = 'KEY_SORT_BY_NAME';
  public static readonly KEY_SORT_BY_TYPE: string = 'KEY_SORT_BY_TYPE';
  public static readonly KEY_SORT_BY_CREATE_TIME: string = 'KEY_SORT_BY_CREATE_TIME';
  public static readonly KEY_SORT_BY_MODIFY_TIME: string = 'KEY_SORT_BY_MODIFY_TIME';
  public static readonly KEY_SORT_BY_SIZE: string = 'KEY_SORT_BY_SIZE';

  public static readonly BUNDLE_NAME_SORT: string = 'SORT';
  public static readonly BUNDLE_NAME_SORT_BY_NAME: string = 'SORT_BY_NAME';
  public static readonly BUNDLE_NAME_SORT_BY_TYPE: string = 'SORT_BY_TYPE';
  public static readonly BUNDLE_NAME_SORT_BY_CREATE_TIME: string = 'SORT_BY_CREATE_TIME';
  public static readonly BUNDLE_NAME_SORT_BY_MODIFY_TIME: string = 'SORT_BY_MODIFY_TIME';
  public static readonly BUNDLE_NAME_SORT_BY_SIZE: string = 'SORT_BY_SIZE';

  public static readonly KEY_DIVIDER_CREATE: string = 'KEY_DIVIDER_CREATE';
  public static readonly KEY_DIVIDER_CREATE_SHORTCUT: string = 'KEY_DIVIDER_CREATE_SHORTCUT';
  public static readonly KEY_DIVIDER_SORT: string = 'KEY_DIVIDER_SORT';
  public static readonly KEY_DIVIDER_COLLABORATION: string = 'KEY_DIVIDER_COLLABORATION';

  public static readonly REPORT_TRIM: number = 1;
  public static readonly REPORT_CREATE_EDIT_WALL_PAPER: number = 2;
  public static readonly REPORT_DISPLAY_SETTINGS: number = 3;

  public static readonly UNDO_SMART_CLEANUP_DESKTOP: string = 'UNDO_SMART_CLEANUP_DESKTOP';
}