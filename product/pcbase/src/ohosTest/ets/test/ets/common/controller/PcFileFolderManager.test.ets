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
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import PcFileFolderManager from '../../../../../../../../pcbase/src/main/ets/common/controller/PcFileFolderManager';
import { GlobalContext, EventManager, EvtBus, } from '@ohos/frameworkwrapper';
import PcFileAccess, { FileObservedChangeEvent } from '../../../../../../../../pcbase/src/main/ets/common/controller/PcFileAccess';
import { DesktopLayoutManager } from '@ohos/pagedesktop/src/main/ets/default/manager/DesktopLayoutManager';
import { MenuInfo, CommonConstants, GridLayoutItemInfo, DesktopFileInfo } from '@ohos/launchercommon';
import { RightMenuNewFileData,RefreshUriListener,FileFolderManager,FileFolderComponent, MenuConstants } from '@ohos/desktopfilefolder';
import { PageDesktopViewModel } from '@ohos/pagedesktop';
import { PcFileFolderConstants } from '../../../../../../../../pcbase/src/main/ets/common/constants/PcFileFolderConstants';
import { image } from '@kit.ImageKit';
import lazy { RegionFolderHelper, RegionFolderLayoutCacheManager,RegionFolderManager,RegionFolderSelect } from '@ohos/regionfolder/Index';
import { CloseAppManager } from '@ohos/launchercommon/src/main/ets/manager/CloseAppManager';
import { CheckEmptyUtils, LogHelper,LogDomain } from '@ohos/basicutils';
import common from '@ohos.app.ability.common';
import HashSet from '@ohos.util.HashSet';
import { ItemUtils } from '@ohos/componenthelper';
import fs from '@ohos.file.fs';
import { ItemParameter } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { BusinessError } from '@ohos.base';

import {
  DragGridPosition,
  DragPosition,
} from '@ohos/componentdrag';
import {PcDesktopLayoutManager} from '../../../../../../../../pcbase/src/main/ets/SceneBoard/systemscene/ViewModel/PcDesktopLayoutManager';
let pcFileFolderManager: PcFileFolderManager;


export default function PcFileFolderManagerTest() {
  describe('PcFileFolderManagerTest', () => {
    let mocker: MockKit;
    beforeAll(() => {
    })
    beforeEach(() => {
      mocker = new MockKit();
      pcFileFolderManager = PcFileFolderManager.getInstance();
    })
    afterEach(() => {
    })
    afterAll(() => {
      mocker.clearAll();
    })

    it('refreshDesktopFilesTest', 0, async () => {
      let firstRefresh: boolean = true;
      let desktopUri: string = "file://desktopUri";
      let mockFunc: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.getDesktop);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(desktopUri);
      await pcFileFolderManager.refreshDesktopFiles(firstRefresh);
    });

    it('handleFileInfoListTest', 0, () => {
      let fileInfoList: FileInfo = new FileInfo()
      let urisMap: Map<string, number[]> = new Map([
        ['file://file1.txt', [2,3]],
        ['file://file2.txt', [4,5,1]],
      ]);
      (pcFileFolderManager as object)['uris'] = urisMap;
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, (pcFileFolderManager as object)['uris'].has);
      when(mockFunc)('file://file1.txt').afterReturn(true);
      let colAndRowFun: Function = mocker.mockFunc(pcFileFolderManager, (pcFileFolderManager as object)['uris'].get);
      const colAndRow: number[] = [2,3];
      when(colAndRowFun)(ArgumentMatchers.anyString).afterReturn(colAndRow);
      (pcFileFolderManager as object)['isFoldersRegistered'] = true;
      (pcFileFolderManager as object)['handleFileInfoList']([fileInfoList]);
    });

    it('openFileOrFolderTest', 0, () => {
      let uri: string = 'file://file1.txt';
      let file: FileInfo = new FileInfo();
      let mockFunc: Function = mocker.mockFunc(FileInfo, FileInfo.fromFileUri);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(file);
      pcFileFolderManager.openFileOrFolder(uri);
    });


    it('getFileFolderPositionOneTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(DesktopLayoutManager, DesktopLayoutManager.getDesktopLayoutManager);
      when(mockFunc)().afterReturn(null);
      const filePosition:DragGridPosition | null = pcFileFolderManager.getFileFolderPosition();
      expect(filePosition).assertNull();
    });

    it('getFileFolderPositionTwoTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(DesktopLayoutManager, DesktopLayoutManager.getDesktopLayoutManager);
      const layoutManager = new PcDesktopLayoutManager()
      DesktopLayoutManager.setDesktopLayoutManager(layoutManager);
      when(mockFunc)().afterReturn(layoutManager);
      let mockFunc2: Function = mocker.mockFunc(layoutManager, layoutManager.getItemPositionInScreen);
      let filePosition: DragGridPosition | null = {row: 1, column: 1, page: 0 }
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(filePosition);
      const result:DragGridPosition | null = pcFileFolderManager.getFileFolderPosition(1, 1, 0);
      expect(result).not().assertNull();
    });

    it('getFileFolderPositionThreeTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(DesktopLayoutManager, DesktopLayoutManager.getDesktopLayoutManager);
      const layoutManager = new PcDesktopLayoutManager()
      DesktopLayoutManager.setDesktopLayoutManager(layoutManager);
      when(mockFunc)().afterReturn(layoutManager);
      let mockFunc2: Function = mocker.mockFunc(layoutManager, layoutManager.getItemPositionInScreen);
      let filePosition: DragGridPosition | null = null
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(filePosition);
      const result: DragGridPosition | null = pcFileFolderManager.getFileFolderPosition();
      expect(result).assertNull();
    });

    it('pushDefaultBlankFileIsNullTest', 0, () => {
      pcFileFolderManager.pushDefaultBlankFile([]);
    });

    it('pushDefaultBlankFileNotNullTest', 0, () => {
      let createSubFolder = new MenuInfo();
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.getNewFileSupportList);
      let newFileDataArray: RightMenuNewFileData[] = [{
        menuName: 'menuName1',
        moduleName: 'moduleName1',
        bundleName: 'bundleName1',
        fileSuffix: 'txt',
        templatePath: 'file://templatePath1',
        iconPath: 'file://iconPath1',
      }
      ]
      when(mockFunc)(ArgumentMatchers.any).afterReturn(newFileDataArray);
      let filePosition: DragGridPosition | null = {
        row: 1, column: 1, page: 0
      }
      let mockFunc4: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.getFileFolderPosition);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(filePosition);
      let mockFunc3: Function = mocker.mockFunc(createSubFolder, createSubFolder.onMenuClick);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      let dirUri: string = "testUri"
      let mockFunc5: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.createNewBlankFile);
      when(mockFunc5)().afterReturn(dirUri);
      let subMenuInfo: MenuInfo[] = [{
        moduleName: 'moduleName1',
        bundleName: 'bundleName1',
        menuType: 0,
        menuImgSrc: 'menuImgSrc1',
        menuText: 'menuText2',
        menuEnabled: true,
        subMenuList: [],
        shortcutIconId: -1,
        shortcutLabelId: -1,
        onMenuClick: (): Function | undefined | null => {
          return null;
        }
      }
      ]
      pcFileFolderManager.pushDefaultBlankFile(subMenuInfo);
      expect(subMenuInfo.length).not().assertNull();
    });

    it('pushDefaultBlankFileAtRegionFolderTest', 0, () => {
      const TAG: string = 'PcFileFolderManager';
      const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
      let mockFunc: Function = mocker.mockFunc(log, log.error);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn('pushDefaultBlankFile failed, subMenuInfo invalid');
      pcFileFolderManager.pushDefaultBlankFileAtRegionFolder([])
    });

    it('pushDefaultBlankFileAtRegionFolderTwoTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.getNewFileSupportList);
      let newFileDataArray: RightMenuNewFileData[] = [{
        menuName: 'menuName1',
        moduleName: 'moduleName1',
        bundleName: 'bundleName1',
        fileSuffix: 'txt',
        templatePath: 'file://templatePath1',
        iconPath: 'file://iconPath1',
      }
      ]
      when(mockFunc)(ArgumentMatchers.any).afterReturn(newFileDataArray);
      let subMenuInfo: MenuInfo[] = [{
        moduleName: 'moduleName1',
        bundleName: 'bundleName1',
        menuType: 0,
        menuImgSrc: 'menuImgSrc1',
        menuText: 'menuText2',
        menuEnabled: true,
        subMenuList: [],
        shortcutIconId: -1,
        shortcutLabelId: -1,
        onMenuClick: (): Function | undefined | null => {
          return null;
        }}]
      pcFileFolderManager.pushDefaultBlankFileAtRegionFolder(subMenuInfo);
    });

    it('parseMenuCachedIconTest', 0, () => {
      let bundleName: string = "com.example.test";
      let moduleHapName: string = "test.hap";
      let iconPath: string = "/icon/test.png";
      let fileSuffix: string = ".txt";
      let resource: Resource = {
        bundleName: 'bundleNameTest',
        moduleName: 'moduleNameTest',
        id: 0
      }
      let menuIconCacheMap: Map<string, Resource | PixelMap> = new Map([
        [ bundleName + moduleHapName + iconPath + fileSuffix, resource ],
      ]);
      (pcFileFolderManager as object)['menuIconCache'] = menuIconCacheMap
      const cacheKey = bundleName + moduleHapName + iconPath + fileSuffix
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, (pcFileFolderManager as object)['menuIconCache'].has);
      when(mockFunc)(cacheKey).afterReturn(true);
      const result: Resource | PixelMap = pcFileFolderManager.parseMenuIcon(bundleName, moduleHapName, iconPath, fileSuffix);
      expect(result).assertEqual(1);
    });

    it('getNewFileSupportListTest', 0, () => {
      let rightMenuExpandManager: RightMenuExpandManager = RightMenuExpandManager.getInstance()
      let mockFunc: Function = mocker.mockFunc(rightMenuExpandManager, rightMenuExpandManager.getNewFileSupportList);
      let newFileData: NewFileData = new NewFileData('bundle', 'module');
      newFileData.menuName = 'test';
      newFileData.fileSuffix = 'txt';
      newFileData.templatePath = 'path';
      newFileData.bundleName = 'bundle';
      newFileData.moduleName = 'module';
      newFileData.iconPath = 'icon';
      when(mockFunc)().afterReturn([newFileData])
      const result = pcFileFolderManager.getNewFileSupportList();
      expect(result.length).assertEqual(1);
    });

    it('createNewBlankFileOneTest', 0, async() => {
      let item: RightMenuNewFileData = {
        bundleName: 'bundleNameTest',
        moduleName: 'moduleNameTest',
        menuName: 'menuNameTest',
        fileSuffix: '.txt',
        templatePath: 'file://filePath',
        iconPath: 'file://fileIconPath'
      };
      let res : BusinessError = {
        name: 'buildNewFileError',
        message: 'build newFile fail',
        code: 404
      }
      let mockFunc: Function = mocker.mockFunc(RightMenuViewUtils, RightMenuViewUtils.buildNewFile);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(res);
      const result: string = pcFileFolderManager.createNewBlankFile(item)
      expect(result).assertEqual(undefined);
    });

    it('createNewBlankFileTwoTest', 0, async() => {
      let item: RightMenuNewFileData = {
        bundleName: 'bundleNameTest',
        moduleName: 'moduleNameTest',
        menuName: 'menuNameTest',
        fileSuffix: '.txt',
        templatePath: 'file://filePath',
        iconPath: 'file://fileIconPath'
      };
      let res: string = 'file://fileUri';
      let mockFunc: Function = mocker.mockFunc(RightMenuViewUtils, RightMenuViewUtils.buildNewFile);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(res);
      const result: string = pcFileFolderManager.createNewBlankFile(item)
      expect(result).assertEqual(res);
    });

    it('createNewBlankFileUriIsNullTest', 0, async() => {
      let item: RightMenuNewFileData = new RightMenuNewFileData();
      const result = await pcFileFolderManager.createNewBlankFile(item, '');
      expect(result).assertEqual('');
    });

    it('deleteFileOrFolderOneTest', 0, async() => {
      let uris: string[] = [];
      await pcFileFolderManager.deleteFileOrFolder(uris);
    });

    it('deleteFileOrFolderTwoTest', 0, async() => {
      let uris: string[] = ['file://'];
      await pcFileFolderManager.deleteFileOrFolder(uris);
    });

    it('deleteFileOrFolderThreeTest', 0, async() => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let uris: string[] = ['file://'];
      let mockFunc: Function = mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.setCutStatusChange);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean]).afterReturnNothing();
      await pcFileFolderManager.deleteFileOrFolder(uris);
    });

    it('copyFilesTest', 0, () => {
      let uris: string[] = ['file://test1', 'file://test2'];
      pcFileFolderManager.copyFiles(uris);
    });

    it('cutFilesTest', 0, () => {
      let uris: string[] = ['file://test1', 'file://test2'];
      pcFileFolderManager.cutFiles(uris);
    });

    it('pasteFilesTest', 0, async () => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mockFunc: Function = mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.setCutStatusChange);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      let destUri: string = "testUri";
      await pcFileFolderManager.pasteFiles(destUri);
    });

    it('createNewFolderTest', 0, async () => {
      try {
        let mockFunc: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.getDesktop);
        let uri:string = 'file://testUri'
        when(mockFunc)(ArgumentMatchers.anyString).afterReturn(uri);
        const result = await pcFileFolderManager.createNewFolder();
        expect(result).not().assertNull();
      } catch (e) {
        expect(e.message).assertEqual("uri is null");
      }
    });

    it('createNewFileTest', 0, async () => {
      let uris: Map<string, number[]> = new Map<string, number[]>();
      pcFileFolderManager.createNewFile(uris);
      expect((pcFileFolderManager as object)['uris']).assertDeepEquals(uris);
    });

    it('reNameTest', 0, async () => {
      let uri: string = 'file://test.txt';
      let name: string = 'test1.txt';
      let renameResult: string = 'file://renameTest.txt'
      let mockFunc: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.rename);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(renameResult);
      const result = await pcFileFolderManager.rename(uri, name);
      expect(result).assertEqual(renameResult);
    });

    it('getFileInfoByUriIsNullTest', 0, async () => {
      let result:DesktopFileInfo | undefined = pcFileFolderManager.getFileInfoByUri('');
      expect(result).assertEqual(undefined);
    });

    it('getFileInfoByUriTest', 0, async () => {
      let result:DesktopFileInfo | undefined = pcFileFolderManager.getFileInfoByUri('someUri');
      expect(result?.uri).assertEqual('someUri');
      expect(result?.fileName).assertEqual('someFileName');
    });

    it('isVideoThumbnailTypeOneTest', 0, async () => {
      let uri: string = 'invalidUri';
      const result: boolean = pcFileFolderManager.isVideoThumbnailType(uri);
      expect(result).assertEqual(false);
    });

    it('isVideoThumbnailTypeTwoTest', 0, async () => {
      let uri: string = 'invalidUri';
      const result: boolean = pcFileFolderManager.isVideoThumbnailType(uri);
      expect(result).assertEqual(true);
    });

    it('isSupportDesktopFileTest', 0, async () => {
      const result: boolean = pcFileFolderManager.isSupportDesktopFile();
      expect(result).assertEqual(true);
    });

    it('isFilesFirstLoadedTest', 0, () => {
      (PcFileFolderManager as object)['firstLoaded '] = true;
      const result: boolean = pcFileFolderManager.isFilesFirstLoaded();
      expect(result).assertEqual(true);
    });

    it('registerRefreshUriOneTest', 0, () => {
      const TAG = 'pcFileFolderManagerTest'
      let mockFunc: Function =
        mocker.mockFunc(pcFileFolderManager, (pcFileFolderManager as object)['refreshUriListeners'].has);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(true);
      pcFileFolderManager.registerRefreshUri('file1.txt', {} as RefreshUriListener);
    });

    it('unregisterRefreshUriOneTest', 0, () => {
      pcFileFolderManager.unregisterRefreshUri('fail');
    });

    it('unregisterRefreshUriTwoTest', 0, () => {
      pcFileFolderManager.unregisterRefreshUri('success');
    });

    it('getDefaultImageIsFolderIsTrueTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.getFileIconResource);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(null);
      const result = pcFileFolderManager.getDefaultImage(true, "test.txt");
      expect(result).not().assertNull();
    });

    it('getDefaultImageIsPixMapIsFalseTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.getFileIconResource);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(null);
      const result = pcFileFolderManager.getDefaultImage(false, "test.txt");
      expect(result).not().assertNull();
    });

    it('getDefaultImageTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.getFileIconResource);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(1);
      const result = pcFileFolderManager.getDefaultImage(false, "test.txt");
      expect(result).not().assertNull();
    });

    it('getDlpImageTest', 0, () => {
      let result = pcFileFolderManager.getDlpImage();
      expect(result).not().assertNull();
    });

    it('getFolderIconResourceOneTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(ThumbnailUtil, ThumbnailUtil.getThumbnailPixMapByUtdTypeId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      let fileName: string = "test.txt";
      const result:string|Resource|PixelMap|null = pcFileFolderManager.getFileIconResource(fileName);
      expect(result).not().assertNull();
    });

    it('getFolderIconResourceTwoTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(ThumbnailUtil, ThumbnailUtil.getThumbnailPixMapByUtdTypeId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      let fileName: string = "test.txt";
      const result: string|Resource|PixelMap|null = pcFileFolderManager.getFileIconResource(fileName);
      expect(result).assertDeepEquals(1);
    });

    it('getRightMenuMinWidthTest', 0, () => {
      const result = pcFileFolderManager.getRightMenuMinWidth();
      expect(result).not().assertNull();
    });

    it('getAllSubMenuTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.getMoreSubMenu);
      let mockFuncTwo: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.getSmartFolderSubMenu);
      let mockMenuInfoArray: MenuInfo[] = [new MenuInfo(), new MenuInfo()];
      when(mockFunc)().afterReturn(mockMenuInfoArray);
      when(mockFuncTwo)().afterReturn(mockMenuInfoArray);
      const result = pcFileFolderManager.getAllSubMenu('testUri');
      expect(result).not().assertNull();
      expect(result.get(MenuConstants.FILE_MENU_MORE_INDEX)).assertDeepEquals(mockMenuInfoArray);
      expect(result.get(MenuConstants.SMART_FOLDER_MENU_INDEX)).assertDeepEquals(mockMenuInfoArray);
    });

    it('getMoreSubMenuOneTest', 0, () => {
      let rightMenuExpandManager: RightMenuExpandManager = RightMenuExpandManager.getInstance()
      let mockFunc: Function = mocker.mockFunc(rightMenuExpandManager, rightMenuExpandManager.getNonBlankMenuList);
      when(mockFunc)().afterReturn(null);
      const result = pcFileFolderManager.getMoreSubMenu();
      expect(result).not().assertNull();
    });

    it('getMoreSubMenuTwoTest', 0, () => {
      let rightMenuExpandManager: RightMenuExpandManager = RightMenuExpandManager.getInstance()
      let mockFunc: Function = mocker.mockFunc(rightMenuExpandManager, rightMenuExpandManager.getNonBlankMenuList);
      let menuKind1: BaseMenuKind = {
        menuName: 'menuName1',
        moduleName:'moduleName1',
        bundleName: 'bundleName1',
        menuAbility: 'menuAbility1',
        menuHandler: 'menuHandler1',
        menuNameResourceId: 1,
        isValid: (): boolean => { return true },
        isEmpty: (str: string): boolean=> {
					return true;
				}
      };
      let baseMenuKind1: BaseMenuKind =
        new BaseMenuKind(menuKind1.bundleName, menuKind1.moduleName, menuKind1.menuAbility, menuKind1.menuName,
          menuKind1.menuHandler, menuKind1.menuNameResourceId,);

      let menuKind2: BaseMenuKind = {
        menuName: 'menuName2',
        moduleName:'moduleName2',
        bundleName: 'bundleName2',
        menuAbility: 'menuAbility2',
        menuHandler: 'menuHandler2',
        menuNameResourceId: 0,
        isValid: (): boolean => { return true },
        isEmpty: (str: string): boolean=> {
          return false;
        }
      };
      let baseMenuKind2: BaseMenuKind =
        new BaseMenuKind(menuKind2.bundleName, menuKind2.moduleName, menuKind2.menuAbility, menuKind2.menuName,
          menuKind2.menuHandler, menuKind2.menuNameResourceId,);
      when(mockFunc)().afterReturn([baseMenuKind1, baseMenuKind2]);
      const result = pcFileFolderManager.getMoreSubMenu()
      expect(result.length).assertEqual(2);
    });

    it('getApplicationIconTest', 0, async (done: Function) => {
      try {
        const result: ESObject = (pcFileFolderManager as object)['getApplicationIcon']('com.example.bundleName');
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).not().assertEqual('error:' + JSON.stringify(e.message));
      } finally {
           done();
      }
    });

    it('getSmartFolderSubMenuTest', 0, () => {
      let rightMenuExpandManager: RightMenuExpandManager = RightMenuExpandManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(rightMenuExpandManager, rightMenuExpandManager.getSmartFolderSubMenuList);
      when(mockFunc)([]).afterReturn([]);
      const result = pcFileFolderManager.getSmartFolderSubMenu();
      expect(result).not().assertNull();
    });

    it('getSmartFolderSubMenuTest', 0, async () => {
      let rightMenuExpandManager: RightMenuExpandManager = RightMenuExpandManager.getInstance();
      let mockFunc: Function =
        mocker.mockFunc(rightMenuExpandManager, rightMenuExpandManager.getSmartFolderSubMenuList);
      let menuKind1: BaseMenuKind = {
        menuName: 'testMenuName1',
        moduleName:'testModuleName1',
        bundleName: 'testBundleName1',
        menuAbility: 'testMenuAbility1',
        menuHandler: 'testMenuHandler1',
        menuNameResourceId: 1,
        isValid: (): boolean => { return true },
        isEmpty: (str: string): boolean=> {
          return true;
        }
      };
      let baseMenuKind1: BaseMenuKind =
        new BaseMenuKind(menuKind1.bundleName, menuKind1.moduleName, menuKind1.menuAbility, menuKind1.menuName,
          menuKind1.menuHandler, menuKind1.menuNameResourceId,);
      let menuKind2: BaseMenuKind = {
        menuName: 'testMenuName2',
        moduleName:'testModuleName2',
        bundleName: 'testBundleName2',
        menuAbility: 'testMenuAbility2',
        menuHandler: 'testMenuHandler2',
        menuNameResourceId: 0,
        isValid: (): boolean => { return true },
        isEmpty: (str: string): boolean=> {
          return false;
        }
      };
      let baseMenuKind2: BaseMenuKind =
        new BaseMenuKind(menuKind2.bundleName, menuKind2.moduleName, menuKind2.menuAbility, menuKind2.menuName,
          menuKind2.menuHandler, menuKind2.menuNameResourceId,);
      when(mockFunc)().afterReturn([baseMenuKind1, baseMenuKind2]);
      const result = pcFileFolderManager.getSmartFolderSubMenu();
      expect(result.length).assertEqual(2);
    });

    it('onRightMenuActionOneTest', 0, () => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(closeAppManager, closeAppManager.setStartAppType);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      pcFileFolderManager.onRightMenuAction(RcmItem.OPEN, [], '');
    });

    it('onRightMenuActionTwoTest', 0, () => {
      let pageDesktopViewModel:PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mockFunc1: Function = mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.initSelectStatus);
      let mockFunc2: Function = mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.selectItemClear);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(null);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(null);
      pcFileFolderManager.onRightMenuAction(RcmItem.OPEN, [], '');
    });

    it('onRightMenuActionThreeTest', 0, () => {
      let pageDesktopViewModel:PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mockFunc: Function = mocker.mockFunc(AppStorage, AppStorage.setOrCreate);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      pcFileFolderManager.onRightMenuAction(RcmItem.RENAME_MULTIPLE, ['file://test1', 'file://test2'], 'currentFile');
    });

    it('onRightMenuActionFourTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(AppStorage, AppStorage.setOrCreate);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      pcFileFolderManager.onRightMenuAction(RcmItem.RENAME, ['file://test1', 'file://test2'], 'currentFile');
    });

    it('onRightMenuActionFiveTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, (pcFileFolderManager as object)['setDialogDefaultPosition']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      pcFileFolderManager.onRightMenuAction(RcmItem.SHARE, ['file://test1', 'file://test2'], '');
    });

    it('onRightMenuActionSixTest', 0, () => {
      pcFileFolderManager.onRightMenuAction(RcmItem.CUT, [], '');
    });

    it('onRightMenuActionSevenTest', 0, () => {
      pcFileFolderManager.onRightMenuAction(RcmItem.CUT_MULTIPLE, [], '');
    });

    it('onRightMenuActionSevenTest', 0, () => {
      let regionFolderLayoutCacheManager:RegionFolderLayoutCacheManager = RegionFolderLayoutCacheManager.getInstance();
      let regionFolderManager:RegionFolderManager = RegionFolderManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(regionFolderLayoutCacheManager, regionFolderLayoutCacheManager.selectFolderBySubItemUri);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn({} as GridLayoutItemInfo);
      let mockFunc3: Function = mocker.mockFunc(RegionFolderManager, regionFolderManager.getSelectHandler);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn({} as RegionFolderSelect);
      pcFileFolderManager.onRightMenuAction(RcmItem.COPY, ['file://test1', 'file://test2'], '');
    });

    it('onRightMenuActionEightTest', 0, () => {
      let regionFolderLayoutCacheManager:RegionFolderLayoutCacheManager = RegionFolderLayoutCacheManager.getInstance();
      let regionFolderManager:RegionFolderManager = RegionFolderManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(regionFolderLayoutCacheManager, regionFolderLayoutCacheManager.selectFolderBySubItemUri);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn({} as GridLayoutItemInfo);
      let mockFunc3: Function = mocker.mockFunc(RegionFolderManager, regionFolderManager.getSelectHandler);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn({} as RegionFolderSelect);
      pcFileFolderManager.onRightMenuAction(RcmItem.COPY_MULTIPLE, ['file://test1', 'file://test2'], '');
    });

    it('getGuiNameByFileInfoUriIsNullTest', 0, () => {
      const result = pcFileFolderManager.getGuiNameByFileInfo('');
      expect(result).assertEqual(undefined);
    });

    it('getGuiNameByFileInfoFileInfoIsNullTest', 0, () => {
      const result = pcFileFolderManager.getGuiNameByFileInfo('file://test1');
      expect(result).not().assertNull();
    });

    it('getGuiNameByFileInfoTest', 0, () => {
      let mockFileInfo: FileInfo = new FileInfo();
      mockFileInfo.fileName = 'testFileInfo';
      let mockFunc: Function = mocker.mockFunc(FileOperation, FileOperation.getGuiNameByFileInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      const result = pcFileFolderManager.getGuiNameByFileInfo('file://test1');
      expect(result).not().assertNull();
    });

    it('getFileExtensionByNameFileNameIsNullTest', 0, () => {
      const result: ESObject = (pcFileFolderManager as object)['getFileExtensionByName']('');
      expect(result).assertEqual(null);
    });

    it('getFileExtensionByNameFileTxtTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, (pcFileFolderManager as object)['getFileExtension']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('.txt');
      const result: ESObject = (pcFileFolderManager as object)['getFileExtensionByName']('test.txt');
      expect(result).assertEqual('.txt');
    });

    it('getFileExtensionByNameFileDlpTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, (pcFileFolderManager as object)['getFileExtension']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('.dlp');
      const result: ESObject = (pcFileFolderManager as object)['getFileExtensionByName']('test.dlp');
      expect(result).assertEqual('.dlp');
    });

    it('getFileExtensionTest', 0, () => {
      let fileName: string = 'testFile';
      let isFolder: boolean = true;
      const result: string = pcFileFolderManager.getFileExtension(fileName, isFolder);
      expect(result).assertEqual('.dlp');
    });

    it('getFileTypeTest', 0, () => {
      let mockFileInfo: FileInfo = new FileInfo();
      mockFileInfo.isFolder = true;
      const result: string = (pcFileFolderManager as object)['getFileType'](mockFileInfo.isFolder);
      expect(result).not().assertNull();
    });

    it('getFileTypeTest', 0, () => {
      let mockFileInfo: FileInfo = new FileInfo();
      mockFileInfo.isFolder = false;
      const result: string = (pcFileFolderManager as object)['getFileType'](mockFileInfo.isFolder);
      expect(result).assertEqual(1);
    });

    it('getThumbnailTest', 0, () => {
      let fileInfo: FileInfo = new FileInfo();
      fileInfo.thumbnailType = 'unknown';
      const result: number = (pcFileFolderManager as object)['getThumbnail'](fileInfo);
      expect(result).assertEqual(0);
    });

    it('getThumbnailIsImageTest', 0, () => {
      let fileInfo: FileInfo = new FileInfo();
      fileInfo.thumbnailType = 'image';
      const result: number = (pcFileFolderManager as object)['getThumbnail'](fileInfo);
      expect(result).assertEqual(0);
    });

    it('getThumbnailIsTextTest', 0, () => {
      let fileInfo: FileInfo = new FileInfo();
      fileInfo.thumbnailType = 'text';
      const result: number = (pcFileFolderManager as object)['getThumbnail'](fileInfo);
      expect(result).not().assertNull();
    });

    it('getThumbnailTwoTest', 0, () => {
      let fileInfo: FileInfo = new FileInfo();
      fileInfo.thumbnailType = 'unknown';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, (pcFileFolderManager as object)['getFileIconResource']);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn($r('app.media.ic_normal_unknown'));
      const result: number = (pcFileFolderManager as object)['getThumbnail'](fileInfo);
      expect(result).not().assertNull();
    });

    it('getThumbnailRetTest', 0, async (done: Function) => {
      try {
        let fileInfo: FileInfo = new FileInfo();
        fileInfo.thumbnailType = 'unknown';
        let mocker: MockKit = new MockKit();
        let mockFunc: Function =
          mocker.mockFunc(pcFileFolderManager, (pcFileFolderManager as object)['getFileIconResource']);
        when(mockFunc)(ArgumentMatchers.anyString).afterReturn(null);
        const result: number = (pcFileFolderManager as object)['getThumbnail'](fileInfo);
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done()
      }
    });

    it('isFileFolderExistOneTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.getFileInfoByUri);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      const result = pcFileFolderManager.isFileFolderExist('testFile.txt', 1);
      expect(result.isExist).assertEqual(false);
    });

    it('isFileFolderExistTwoTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.getFileInfoByUri);
      let mockFileInfo: DesktopFileInfo = {
        fileType: 1,
        uri: 'fileUriTest'
      };
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(mockFileInfo);
      const result = pcFileFolderManager.isFileFolderExist('testFile.txt', 1);
      expect(result).not().assertNull();
    });

    it('spaceDataTransferTest', 0, () => {
      (pcFileFolderManager as object)['spaceDataTransfer']('desktopUri', []);
    });

    it('spaceDataTransferTwoTest', 0, async (done: Function) => {
      try {
        let globalHolder: GlobalHolder = GlobalHolder.getInstance();
        let context = globalHolder.getCommonContext() as common.ServiceExtensionContext
        const mockFunc: Function = mocker.mockFunc(context, context?.startAbility);
        when(mockFunc)(ArgumentMatchers.anyString).afterReturn('startAbility Success');
        (pcFileFolderManager as object)['spaceDataTransfer']('desktopUri', ['file1', 'file2']);
      } catch (e) {
        expect(e).assertEqual('startAbility err: ' + JSON.stringify(e.message));
      } finally {
        done()
      }
    });

    it('jsonParseOneTest', 0, () => {
      let input: string = '{"key": "value"}';
      const result: Object =  (pcFileFolderManager as object)['jsonParse']<Object>(input);
      expect(result).assertDeepEquals({ key: 'value' });
    });

    it('jsonParseTwoTest', 0, () => {
      let input: string = 'invalid json';
      const result: Object = (pcFileFolderManager as object)['jsonParse']<Object>(input);
      expect(result).assertUndefined();
    });

    it('unregisterFolderChangeTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.stopListenFolder);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(1);
      pcFileFolderManager.unregisterFolderChange('testUri');
    });

    it('onDesktopIconChangeTest', 0, () => {
      let mockFunc: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.listFilesOfFolder);
      let mockFileInfo1: DesktopFileInfo = {
        fileType: 1,
        uri: 'fileUriTest1'
      };
      let mockFileInfo2: DesktopFileInfo = {
        fileType: 0,
        uri: 'fileUriTest2'
      };
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn([mockFileInfo1,mockFileInfo2]);
      let result: HashSet<FileObserveResultModel> = new HashSet<FileObserveResultModel>();
      (pcFileFolderManager as object)['onDesktopIconChange'](result);
    });

    it('subscribeFileItemStateChangedTest', 0, async () => {
      let eventBus: EventManager = EvtBus.createEventManager()
      let mockFunc: Function = mocker.mockFunc(eventBus, eventBus.on);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      await (pcFileFolderManager as object)['subscribeFileItemStateChanged'];
    });

    it('onDesktopFileChangeOneTest', 0, async () => {
      (pcFileFolderManager as object)['onDesktopFileChange'](null);
    });

    it('onDesktopFileChangeTwoTest', 0, async () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.refreshDesktopFiles);
      when(mockFunc)().afterReturnNothing();
      let result: FileObserveResultModel[] = [
        {
          event:FileObservedChangeEvent.IN_DELETE,
          ino: '1234',
          uri: 'testUri1',
          oldUri:'testOldUri1',
          currentListenUri:'currentUri1'
        },
        {
          event: FileObservedChangeEvent.IN_CLOSE_WRITE,
          ino: '4567',
          uri: 'testUri2',
          oldUri:'testOldUri2',
          currentListenUri:'currentUri2'
        },
      ];
      (pcFileFolderManager as object)['onDesktopFileChange'](result);
    });

    it('onDesktopFileChangeThreeTest', 0, async () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.refreshDesktopFiles);
      when(mockFunc)().afterReturnNothing();
      let mockFunc2: Function = mocker.mockFunc(pcFileFolderManager, (pcFileFolderManager as object)['refreshUriListeners']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();
      let result: FileObserveResultModel[] = [
        {
          event:FileObservedChangeEvent.IN_DELETE,
          ino: '1234',
          uri: 'testUri1',
          oldUri:'testOldUri1',
          currentListenUri:'currentUri1'
        },
        {
          event: FileObservedChangeEvent.IN_CLOSE_WRITE,
          ino: '4567',
          uri: 'testUri2',
          oldUri:'testOldUri2',
          currentListenUri:'currentUri2'
        },
        {
          event: FileObservedChangeEvent.IN_MOVED_TO,
          ino: '4789',
          uri: 'testUri3',
          oldUri:'testOldUri3',
          currentListenUri:'currentUri3'
        },
      ];
      (pcFileFolderManager as object)['onDesktopFileChange'](result);
    });

    it('isRecycleBinOneTest', 0, async () => {
      const result = pcFileFolderManager.isRecycleBin(undefined, undefined);
      expect(result).assertEqual(false);
    });

    it('isRecycleBinTwoTest', 0, async () => {
      const result = pcFileFolderManager.isRecycleBin('OTHER_BUNDLE', 123);
      expect(result).assertEqual(false);
    });

    it('isRecycleBinThreeTest', 0, async () => {
      const result = pcFileFolderManager.isRecycleBin(CommonConstants.FILE_MANAGER_BUNDLE, 123, true, true);
      expect(result).assertEqual(false);
    });

    it('isRecycleBinFourTest', 0, async () => {
      (pcFileFolderManager as object)['recycleBinWindowIdList'] = [123];
      const result = pcFileFolderManager.isRecycleBin(CommonConstants.FILE_MANAGER_BUNDLE, 123, true, true);
      expect(result).not().assertNull();
    });

    it('refreshRecycleBinIconStateOneTest', 0, async () => {
      pcFileFolderManager.refreshRecycleBinIconState();
    });

    it('refreshRecycleBinIconStateTest', 0, async () => {
      pcFileFolderManager.refreshRecycleBinIconState();
    });

    it('registerRecycleBinListenerTest', 0, () => {
      pcFileFolderManager.registerRecycleBinListener(1, () => {});
      expect((pcFileFolderManager as object)['fileCallbackMap'].size).assertEqual(1);
    });

    it('unRegisterRecycleBinListenerOneTest', 0, () => {
      pcFileFolderManager.unRegisterRecycleBinListener(1)
    });

    it('unRegisterRecycleBinListenerTwoTest', 0, () => {
      pcFileFolderManager.unRegisterRecycleBinListener(1)
      expect((pcFileFolderManager as object)['fileCallbackMap'].size).assertEqual(0);
      expect((pcFileFolderManager as object)['fileCallbackMap'].has(1)).assertFalse();
    });

    it('doRevokeTest', 0, () => {
      pcFileFolderManager.doRevoke();
    });

    it('canUndoTest', 0, async () => {
      try {
        const result = await pcFileFolderManager.canUndo();
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('canUndo fail, code: ' + JSON.stringify(e.message));
      }
    });

    it('getUndoTextTest', 0, async () => {
      try {
        const result:string = pcFileFolderManager.getUndoText();
        expect(result).not().assertNull();
        expect(result).assertEqual('');
      } catch (e) {
        expect(e).assertEqual('getUndoText fail, code: ' + JSON.stringify(e.message));
      }
    });

    it('doReverseRevokeTest', 0, async () => {
      pcFileFolderManager.doReverseRevoke();
    });

    it('canRedoTest', 0, async () => {
      try {
        const result = await pcFileFolderManager.canRedo();
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('canRedo fail, code: ' + JSON.stringify(e.message));
      }
    });

    it('getRedoTextTest', 0, async () => {
      try {
        const result:string = await pcFileFolderManager.getUndoText();
        expect(result).not().assertNull();
        expect(result).assertEqual('');
      } catch (e) {
        expect(e).assertEqual('getRedoText fail, code: ' + JSON.stringify(e.message));
      }
    });

    it('openFileDetailTest', 0, async () => {
      let fileUri: string[] = ['invalid_uri'];
      pcFileFolderManager.openFileDetail(fileUri);
    });

    it('openFileDetailTwoTest', 0, async () => {
      let mockFunc: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn({ left: '10', bottom: '20' });
      let fileUri: string[] = ['invalid_uri', 'invalid_uri1'];
      pcFileFolderManager.openFileDetail(fileUri, false);
    });

    it('openFileDetailThreeTest', 0, async () => {
      let mockFunc: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn({ left: '20', bottom: '30' });
      let fileUri: string[] = ['invalid_uri', 'invalid_uri1'];
      pcFileFolderManager.openFileDetail(fileUri, true);
    });

    it('openFilePreviewTest', 0, async () => {
      pcFileFolderManager.openFilePreview('');
    });

    it('openFilePreviewTwoTest', 0, async () => {
      let mockFunc: Function = mocker.mockFunc(FileOperation, FileOperation.quickViewByService);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      pcFileFolderManager.openFilePreview('testFileUri');
    });

    it('setRightClickPositionTest', 0, () => {
      pcFileFolderManager.setRightClickPosition(100, 200);
      expect((pcFileFolderManager as object)['rightClickPosition']).assertDeepEquals({ x: 100, y: 200 });
    });

    it('setMenuShowStatusFalseTest', 0, () => {
      pcFileFolderManager.setMenuShowStatus(false);
      expect((pcFileFolderManager as object)['isMenuShow']).assertEqual(false);
    });

    it('setMenuShowStatusTrueTest', 0, () => {
      pcFileFolderManager.setMenuShowStatus(true);
      expect((pcFileFolderManager as object)['isMenuShow']).assertEqual(true);
    });

    it('getMenuShowStatusTrueTest', 0, () => {
      (pcFileFolderManager as object)['isMenuShow']= true;
      pcFileFolderManager.getMenuShowStatus();
      expect((pcFileFolderManager as object)['isMenuShow']).assertEqual(true);
    });

    it('getExtraOneTest', 0, () => {
      let result: string = (pcFileFolderManager as object)['getExtra']();
      expect(result).assertEqual('');
    });

    it('getExtraTwoTest', 0, () => {
      let result: string = (pcFileFolderManager as object)['getExtra']();
      expect(result).assertEqual('');
    });

    it('getExtraTwoTest', 0, () => {
      let extraParams: string = '{"extraInfo": "testInfo"}';
      let result: string = (pcFileFolderManager as object)['getExtra'](extraParams);
      expect(result).assertEqual('testInfo');
    });

    it('createNewFileByDragOneTest', 0, async () => {
      try {
        let mockFunc: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.getDesktop);
        when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();
        let newFilePos: number[] = [2, 4]
        const result: string = (pcFileFolderManager as object)['createNewFileByDrag'](newFilePos);
        expect(result).assertEqual('testInfo');
      } catch (e) {
        expect(e).assertEqual('create NewFile By Drag error');
      }
    });

    it('createNewFileByDragTwoTest', 0, async () => {
      try {
        let fileNamesAndIsFolder: Map<string, boolean> = new Map([
          ['file1.txt', true],
          ['file2.txt', false],
        ]);
        let newFilePos: number[] = [2, 4]
        let mockFunc: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.getDesktop);
        when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();
        let mockFunc2: Function = mocker.mockFunc(ThreadCommonUtil, ThreadCommonUtil.getDupFileNameForDesktop);
        when(mockFunc2)(ArgumentMatchers.anyString).afterReturn(['fileUri1','fileUri2']);
        const result: string = (pcFileFolderManager as object)['createNewFileByDrag'](newFilePos);
        expect((pcFileFolderManager as object)['uris'].size).assertEqual(2);
        expect(result).assertEqual(2);
      } catch (e) {
        expect(e).assertEqual('create NewFile By Drag error');
      }
    });

    it('getFileSummaryByUriOneTest', 0, async () => {
      let mockFunc: Function = mocker.mockFunc(FileInfo, FileInfo.fromFileUri);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(null);
      const result: ESObject = pcFileFolderManager.getFileSummaryByUri('invalid_file_uri', -1);
      expect(result).assertDeepEquals([]);
    });

    it('getFileSummaryByUriTwoTest', 0, async () => {
      let mockFunc: Function = mocker.mockFunc(FileInfo, FileInfo.fromFileUri);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(2);
      let summaryRes: string[] = ['summary1', 'summary2'];
      let mockFunc2: Function = mocker.mockFunc(FileOperation,FileOperation.getFileSummary);
      when(mockFunc2)(ArgumentMatchers.anyString).afterReturn(summaryRes);
      const result: ESObject = pcFileFolderManager.getFileSummaryByUri('invalid_file_uri', 20);
      expect(result).assertDeepEquals(summaryRes);
    });

    it('getFolderSizeByUriOneTest', 0, async () => {
      const result = await pcFileFolderManager.getFolderSizeByUri("validUri");
      expect(result).assertEqual(0);
    });

    it('getFolderSizeByUriTwoTest', 0, async () => {
      const result: ESObject = await pcFileFolderManager.getFolderSizeByUri("invalidUri");
      expect(result).not().assertNull();
    });

    it('pasteFileToFixedPageTest', 0, async () => {
      let mockFunc1: Function = mocker.mockFunc(PasteBoardUtil, PasteBoardUtil.getPasteData);
      when(mockFunc1)().afterReturn({ fileUriList: ['file://test'] });

      let mockFunc2: Function = mocker.mockFunc(PasteBoardUtil, PasteBoardUtil.getUriFromPasteboard);
      when(mockFunc2)({ fileUriList: ['file://test'] }).afterReturn({ fileUriList: ['file://test'] });

      await pcFileFolderManager.pasteFileToFixedPage(1);
    });

    it('createSmartNewFolderTest', 0, async () => {
      pcFileFolderManager.createSmartNewFolder();
    });

    it('moveFileTest', 0, async () => {
      try {
        let mockFunc: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.moveFile);
        when(mockFunc)().afterReturn('testUri1');
        await pcFileFolderManager.moveFile('srcUri', 'destUri');
      } catch (e) {
        expect(e.message).assertEqual('Move file failed');
      }
    });

    it('moveFileTest', 0, async () => {
      try {
        let mockFunc: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.moveFile);
        when(mockFunc)().afterReturn('testUri1');
        await pcFileFolderManager.moveFile('srcUri', 'destUri');
      } catch (e) {
        expect(e.message).assertEqual('Move file failed');
      }
    });

    it('moveFileToDesktopTest', 0, async () => {
      let mockFunc: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.getDesktop);
      when(mockFunc)().afterReturn("desktopUri");
      let mockFunc2: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.moveFile);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn("destUri");
      const result: ESObject = await pcFileFolderManager.moveFileToDesktop("src_uri");
      expect(result).not().assertNull();
    });

    it('listFilesOfFolderTest', 0, async () => {
      let uri: string = 'testUri';
      let callback: Function = (desktopFileArrays: DesktopFileInfo[]) => { };
      let mockFunc: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.listFilesOfFolder);
      let resultArray: FileInfo[] = [
        new FileInfo(),
        new FileInfo(),
      ];
      when(mockFunc)(ArgumentMatchers.any).afterAction((uri: string, callback: Function) => {
        callback(resultArray);
      });
      pcFileFolderManager.listFilesOfFolder(uri, callback);
    });

    it('listFilesOfFolderTest', 0, async () => {
      let uri: string = 'testUri';
      let callback: Function = (desktopFileArrays: DesktopFileInfo[]) => { };
      let mockFunc: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.listFilesOfFolder);
      let resultArray: FileInfo[] = [
        new FileInfo(),
        new FileInfo(),
      ];
      when(mockFunc)(ArgumentMatchers.any).afterAction((uri: string, callback: Function) => {
        callback(resultArray);
      });
      pcFileFolderManager.listFilesOfFolder(uri, callback);
    });

    it('deleteFileOrFolderByNameOneTest', 0, async () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.getFolderUriByName);

      when(mockFunc)(ArgumentMatchers.anyString).afterReturn('testUri');
      await pcFileFolderManager.deleteFileOrFolderByName('testFileName');
    });

    it('deleteFileOrFolderByNameTwoTest', 0, async () => {
      let mockFunc: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.getFolderUriByName);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn('testUri');
      await pcFileFolderManager.deleteFileOrFolderByName('testFileName');
    });

    it('getFolderUriByNameTest', 0, async () => {
      let fileName: string = "testFile";
      let targetUri: string = "customPath";
      let result: string = pcFileFolderManager.getFolderUriByName(fileName, targetUri);
      expect(result).not().assertNull();
    });

    it('getRightMenuInfoOneTest', 0, async () => {
      let currentFile: string = "currentFile";
      let selectFile: string[] = ['selectFile1', 'selectFile2'];
      let pageDesktopViewModel:PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mockFunc: Function = mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.selectItemContainApp);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(true);
      let regionFolder: GridLayoutItemInfo = new GridLayoutItemInfo()
      let regionFolderLayoutCacheManager:RegionFolderLayoutCacheManager = RegionFolderLayoutCacheManager.getInstance();
      let mockFunc2: Function = mocker.mockFunc(regionFolderLayoutCacheManager, regionFolderLayoutCacheManager.selectFolderBySubItemUri);
      when(mockFunc2)(ArgumentMatchers.anyString).afterReturn(regionFolder);
      const result = pcFileFolderManager.getRightMenuInfo(currentFile, selectFile);
      expect(result).not().assertNull();
    });

    it('getRightMenuInfoTwoTest', 0, async () => {
      let currentFile: string = "currentFile";
      let selectFiles: string[] = ['selectFile1', 'selectFile2'];
      let pageDesktopViewModel:PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mockFunc: Function = mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.selectItemContainApp);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(false);
      let regionFolderLayoutCacheManager:RegionFolderLayoutCacheManager = RegionFolderLayoutCacheManager.getInstance();
      let mockFunc2: Function = mocker.mockFunc(regionFolderLayoutCacheManager, regionFolderLayoutCacheManager.selectFolderBySubItemUri);
      when(mockFunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let cFile:FileInfo = new FileInfo();
      let mockFunc3: Function = mocker.mockFunc(FileInfo, FileInfo.fromFileUri);
      when(mockFunc3)(ArgumentMatchers.anyString).afterReturn(cFile);
      let rightMenuInfo: RightMenuInfo = new RightMenuInfo(
        cFile,
        selectFiles,
        selectFiles.indexOf(currentFile) > -1,
        selectFiles.length > 1,
        UnityStartMode.DESKTOP_FILE_START
      );
      let point: Point = new Point(3,4);
      rightMenuInfo.detailPoint = point;
      let mockFunc4: Function = mocker.mockFunc(PcFileAccess, PcFileAccess.getShowMenuItem);
      when(mockFunc4)(ArgumentMatchers.anyString).afterReturn(170);
      const result = pcFileFolderManager.getRightMenuInfo(currentFile, selectFiles);
      expect(result).not().assertNull();
    });

  })
}