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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
} from '@ohos/hypium'
import {
  BigFolderViewModel,
  FolderLayoutStruct,
  DragItemFromFolderStartInfo,
  Callback,
  GridLayoutItemInfo,
  FolderItemInfo,
  FolderCloseType,
  AppItemInfo,
  GridLayoutItemBuilder,
} from '../../../../../../bigfolder/index';
import { FileUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import {
  IconEditViewModel,
  FOLDER_EXPAND_ICONS,
  PATH_ICONS,
  FORMAT_PNG,
  FORMAT_WEBP
} from '../../../../main/ets/uiExtension/viewmodel/IconEditViewModel';
import { EditModeConstants, WantParams } from '../../../../main/ets/default/common/constants/EditModeConstants';
import IconEditPageConstants from '../../../../main/ets/default/common/constants/IconEditPageConstants';
import { BigFolderStyleConfig } from '@ohos/launchercommon';

/**
 * SmallFolderViewModel测试
 *
 * @since 2023-11-14
 */
export default function EditModeCommonTest() {
  describe('EditModeCommonTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      globalThis.FolderViewModelInstance = null;
      let instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(instance).assertEqual(globalThis.FolderViewModelInstance);
      expect(instance).assertEqual(BigFolderViewModel.getInstance());
    })
    it('test_getFolderStyleConfig', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const folderStyleConfig: BigFolderStyleConfig = BigFolderViewModelInstance.getFolderStyleConfig();
      expect(folderStyleConfig).assertEqual(BigFolderViewModelInstance.getFolderStyleConfig());
    })
    it('test_getFolderLayoutConfig', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const folderLayoutConfig: FolderLayoutStruct = BigFolderViewModelInstance.getFolderLayoutConfig();
      expect(folderLayoutConfig).assertEqual(BigFolderViewModelInstance.getFolderLayoutConfig());
    })
    it('test_dropInFolderOpenComponent', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.dropInFolderOpenComponent() === undefined).assertTrue();
    })
    it('test_setDragFromFolderStartInfo', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const page: number | undefined = undefined;
      const row: number | undefined = undefined;
      const column: number | undefined = undefined;
      const bundleName: string | undefined = undefined;
      const folderId: string | undefined = undefined;
      const dragItemFolderPosition: number[] = [];
      const data: DragItemFromFolderStartInfo = {
        page,
        row,
        column,
        bundleName,
        folderId,
        dragItemFolderPosition,
      }
      expect(data.page).assertEqual(page);
      expect(data.row).assertEqual(row);
      expect(data.column).assertEqual(column);
      expect(data.bundleName).assertEqual(bundleName);
      expect(data.folderId).assertEqual(folderId);
      expect(data.dragItemFolderPosition).assertEqual(dragItemFolderPosition);
      expect(BigFolderViewModelInstance.setDragFromFolderStartInfo(data) === undefined).assertTrue();
    })
    it('test_getDragFromFolderStartInfo', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const dragFromFolderStartInfo: DragItemFromFolderStartInfo = BigFolderViewModelInstance.getDragFromFolderStartInfo();
      expect(dragFromFolderStartInfo).assertEqual(BigFolderViewModelInstance.getDragFromFolderStartInfo());
    })
    it('test_getNewFolderName', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const newFolderName: Promise<string> = BigFolderViewModelInstance.getNewFolderName();
      expect(newFolderName).assertEqual(BigFolderViewModelInstance.getNewFolderName());
    })
    it('test_runFolderDropAnimateWaitCallBack', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.runFolderDropAnimateWaitCallBack() === undefined).assertTrue();
      BigFolderViewModelInstance.setDropAnimationStart();
      const callback: Callback<void> = () => {
      };
      BigFolderViewModelInstance.pushDropAnimationCallBack(callback);
      expect((BigFolderViewModelInstance.runFolderDropAnimateWaitCallBack() === undefined)).assertTrue()
    })
    it('test_setDropAnimationStart', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.setDropAnimationStart() === undefined).assertTrue();
    })
    it('test_getDropAnimationStatus', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const dropAnimationStatus: boolean = BigFolderViewModelInstance.getDropAnimationStatus();
      expect(dropAnimationStatus).assertEqual(BigFolderViewModelInstance.getDropAnimationStatus());
    })
    it('test_pushDropAnimationCallBack', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      expect(BigFolderViewModelInstance.pushDropAnimationCallBack(callback) === undefined).assertTrue();
      expect(BigFolderViewModelInstance.pushDropAnimationCallBack(callback) === undefined).assertTrue();
    })
    it('test_setAppLaunchTime', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect((BigFolderViewModelInstance.setAppLaunchTime() === undefined)).assertTrue();
    })
    it('test_isAppLaunching', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const isAppLaunching: boolean = BigFolderViewModelInstance.isAppLaunching();
      expect(isAppLaunching).assertEqual(BigFolderViewModelInstance.isAppLaunching());
    })
    it('test_registerFolderListener', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.registerFolderListener() === undefined).assertTrue();
    })
    it('test_unregisterFolderListener', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.unregisterFolderListener() === undefined).assertTrue();
    })
    it('test_openFolder01', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const layoutInfo: Array<GridLayoutItemInfo[]> = [];
      const folderItem: FolderItemInfo | GridLayoutItemInfo = {
        layoutInfo,
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      expect(folderItem.layoutInfo).assertEqual(layoutInfo);
      expect(folderItem.bundleName).assertEqual(bundleName);
      expect(folderItem.abilityName).assertEqual(abilityName);
      expect(folderItem.appIconId).assertEqual(appIconId);
      expect(folderItem.negativeId).assertEqual(negativeId);
      expect(folderItem.isSelect).assertEqual(isSelect);
      expect(folderItem.enterEditing).assertEqual(enterEditing);
      expect(folderItem.downloadProgress).assertEqual(downloadProgress);
      expect(folderItem.appStatus).assertEqual(appStatus);
      expect(folderItem.iconResource).assertEqual(iconResource);
      expect(folderItem.callerName).assertEqual(callerName);
      expect(folderItem.centerAniX).assertEqual(centerAniX);
      expect(folderItem.centerAniY).assertEqual(centerAniY);
      expect(await BigFolderViewModelInstance.openFolder(true, folderItem, true) === undefined).assertTrue();
    })
    it('test_openFolder02', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const layoutInfo: Array<GridLayoutItemInfo[]> = [[{
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        typeId: 3,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }]];
      const folderItem: FolderItemInfo | GridLayoutItemInfo = {
        layoutInfo,
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      expect(folderItem.layoutInfo).assertEqual(layoutInfo);
      expect(folderItem.bundleName).assertEqual(bundleName);
      expect(folderItem.abilityName).assertEqual(abilityName);
      expect(folderItem.appIconId).assertEqual(appIconId);
      expect(folderItem.negativeId).assertEqual(negativeId);
      expect(folderItem.isSelect).assertEqual(isSelect);
      expect(folderItem.enterEditing).assertEqual(enterEditing);
      expect(folderItem.downloadProgress).assertEqual(downloadProgress);
      expect(folderItem.appStatus).assertEqual(appStatus);
      expect(folderItem.iconResource).assertEqual(iconResource);
      expect(folderItem.callerName).assertEqual(callerName);
      expect(folderItem.centerAniX).assertEqual(centerAniX);
      expect(folderItem.centerAniY).assertEqual(centerAniY);
      expect(await BigFolderViewModelInstance.openFolder(true, folderItem, true) === undefined).assertTrue();
    })
    it('test_openFolder03', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const layoutInfo: Array<GridLayoutItemInfo[]> = [[{
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        typeId: 3,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }]];
      const folderItem: FolderItemInfo | GridLayoutItemInfo = {
        layoutInfo,
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      expect(folderItem.layoutInfo).assertEqual(layoutInfo);
      expect(folderItem.bundleName).assertEqual(bundleName);
      expect(folderItem.abilityName).assertEqual(abilityName);
      expect(folderItem.appIconId).assertEqual(appIconId);
      expect(folderItem.negativeId).assertEqual(negativeId);
      expect(folderItem.isSelect).assertEqual(isSelect);
      expect(folderItem.enterEditing).assertEqual(enterEditing);
      expect(folderItem.downloadProgress).assertEqual(downloadProgress);
      expect(folderItem.appStatus).assertEqual(appStatus);
      expect(folderItem.iconResource).assertEqual(iconResource);
      expect(folderItem.callerName).assertEqual(callerName);
      expect(folderItem.centerAniX).assertEqual(centerAniX);
      expect(folderItem.centerAniY).assertEqual(centerAniY);
      expect(await BigFolderViewModelInstance.openFolder(true, folderItem, false) === undefined).assertTrue();
    })
    it('test_openFolder04', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const layoutInfo: Array<GridLayoutItemInfo[]> = [[{
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        typeId: 3,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }]];
      const folderItem: FolderItemInfo | GridLayoutItemInfo = {
        layoutInfo,
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      expect(folderItem.layoutInfo).assertEqual(layoutInfo);
      expect(folderItem.bundleName).assertEqual(bundleName);
      expect(folderItem.abilityName).assertEqual(abilityName);
      expect(folderItem.appIconId).assertEqual(appIconId);
      expect(folderItem.negativeId).assertEqual(negativeId);
      expect(folderItem.isSelect).assertEqual(isSelect);
      expect(folderItem.enterEditing).assertEqual(enterEditing);
      expect(folderItem.downloadProgress).assertEqual(downloadProgress);
      expect(folderItem.appStatus).assertEqual(appStatus);
      expect(folderItem.iconResource).assertEqual(iconResource);
      expect(folderItem.callerName).assertEqual(callerName);
      expect(folderItem.centerAniX).assertEqual(centerAniX);
      expect(folderItem.centerAniY).assertEqual(centerAniY);
      const callback: Callback<void> = () => {
      };
      await BigFolderViewModelInstance.waitFolderOpenFinish(callback);
      expect(await BigFolderViewModelInstance.openFolder(false, folderItem, false) === undefined).assertTrue();
    })
    it('test_waitFolderMoveAniamtion', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      expect(BigFolderViewModelInstance.waitFolderMoveAniamtion(callback) === undefined).assertTrue();
    })
    it('test_excuteAfterMoveAnimation', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(await BigFolderViewModelInstance.excuteAfterMoveAnimation() === undefined).assertTrue();
      BigFolderViewModelInstance.waitFolderMoveAniamtion(() => {
      });
      expect(await BigFolderViewModelInstance.excuteAfterMoveAnimation() === undefined).assertTrue();
    })
    it('test_waitFolderAnimateFinish', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      expect(await BigFolderViewModelInstance.waitFolderAnimateFinish(callback) === undefined).assertTrue();
      BigFolderViewModelInstance.startTransitionAnimation(true, '');
      expect(await BigFolderViewModelInstance.waitFolderAnimateFinish(callback) === undefined).assertTrue();
    })
    it('test_waitFolderOpenFinish', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      expect(await BigFolderViewModelInstance.waitFolderOpenFinish(callback) === undefined).assertTrue();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const layoutInfo: Array<GridLayoutItemInfo[]> = [[{
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        typeId: 3,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }]];
      const folderItem: FolderItemInfo | GridLayoutItemInfo = {
        layoutInfo,
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      await BigFolderViewModelInstance.openFolder(false, folderItem, false);
      expect(await BigFolderViewModelInstance.waitFolderOpenFinish(callback) === undefined).assertTrue();
    })
    it('test_setCloseType', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const type: FolderCloseType = FolderCloseType.CLICK_BLANK;
      expect(BigFolderViewModelInstance.setCloseType(type) === undefined).assertTrue();

    })
    it('test_getCloseType', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const type: FolderCloseType = FolderCloseType.BACK_GESTURE;
      BigFolderViewModelInstance.setCloseType(type);
      const closeType: string = BigFolderViewModelInstance.getCloseType();
      expect(closeType).assertEqual(FolderCloseType.BACK_GESTURE);
    })
    it('test_closeFolderPending01', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const layoutInfo: Array<GridLayoutItemInfo[]> = [[{
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        typeId: 3,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }]];
      const folderItem: FolderItemInfo | GridLayoutItemInfo = {
        folderId: '-1',
        layoutInfo,
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      await BigFolderViewModelInstance.openFolder(false, folderItem, false);
      const callback: Callback<void> = () => {
      };
      expect(await BigFolderViewModelInstance.closeFolderPending(true, callback) === undefined).assertTrue();
    })
    it('test_closeFolderPending02', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const layoutInfo: Array<GridLayoutItemInfo[]> = [[{
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        typeId: 3,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }]];
      const folderItem: FolderItemInfo | GridLayoutItemInfo = {
        folderId: '1',
        layoutInfo,
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      await BigFolderViewModelInstance.openFolder(false, folderItem, false);
      const callback: Callback<void> = () => {
      };
      expect(await BigFolderViewModelInstance.closeFolderPending(false, callback) === undefined).assertTrue();
    })
    it('test_closeFolder01', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const layoutInfo: Array<GridLayoutItemInfo[]> = [[{
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        typeId: 3,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }]];
      const folderItem: FolderItemInfo | GridLayoutItemInfo = {
        folderId: '-1',
        layoutInfo,
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      await BigFolderViewModelInstance.openFolder(false, folderItem, false);
      const callback: Callback<void> = () => {
      };
      expect(await BigFolderViewModelInstance.closeFolder(callback, false) === undefined).assertTrue();
    })
    it('test_closeFolder02', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const layoutInfo: Array<GridLayoutItemInfo[]> = [[{
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        typeId: 3,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }]];
      const folderItem: FolderItemInfo | GridLayoutItemInfo = {
        folderId: '1',
        layoutInfo,
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      await BigFolderViewModelInstance.openFolder(false, folderItem, false);
      const callback: Callback<void> = () => {
      };
      expect(await BigFolderViewModelInstance.closeFolder(callback, true) === undefined).assertTrue();
    })
    it('test_refreshFolder01', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const layoutInfo: Array<GridLayoutItemInfo[]> = [];
      const folderItem: FolderItemInfo | GridLayoutItemInfo = {
        folderId: '',
        layoutInfo,
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      expect(await BigFolderViewModelInstance.refreshFolder(folderItem) === undefined).assertTrue();
    })
    it('test_refreshFolder02', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const layoutInfo: Array<GridLayoutItemInfo[]> = [];
      const folderItem: FolderItemInfo | GridLayoutItemInfo = {
        folderId: '1',
        layoutInfo,
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      expect(await BigFolderViewModelInstance.refreshFolder(folderItem) === undefined).assertTrue();
    })
    it('test_getIsPad', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const isPad: boolean = BigFolderViewModelInstance.getIsPad();
      expect(isPad).assertEqual(BigFolderViewModelInstance.getIsPad());
    })
    it('test_startTransitionAnimation', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const layoutInfo: Array<GridLayoutItemInfo[]> = [[{
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        typeId: 3,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }]];
      const folderItem: FolderItemInfo | GridLayoutItemInfo = {
        folderId: '1',
        layoutInfo,
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      await BigFolderViewModelInstance.openFolder(false, folderItem, false);
      const callback: Callback<void> = () => {
      };
      await BigFolderViewModelInstance.closeFolder(callback, true);
      const folderId = '1';
      expect(BigFolderViewModelInstance.startTransitionAnimation(true, folderId, true) === undefined).assertTrue();
      expect(BigFolderViewModelInstance.startTransitionAnimation(false, folderId, false) === undefined).assertTrue();
    })
    it('test_getFolderAnimationCount', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const folderAnimationCount: number = BigFolderViewModelInstance.getFolderAnimationCount();
      expect(folderAnimationCount).assertEqual(BigFolderViewModelInstance.getFolderAnimationCount());
    })
    it('test_getTransitingFolderId', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const transitingFolderId: string = BigFolderViewModelInstance.getTransitingFolderId();
      expect(transitingFolderId).assertEqual(BigFolderViewModelInstance.getTransitingFolderId());
    })
    it('test_changeIndexOnly', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.changeIndexOnly(1) === undefined).assertTrue();
    })
    it('test_changeIndex', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.changeIndex(1) === undefined).assertTrue();
    })
    it('test_getIndex', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const index: number = BigFolderViewModelInstance.getIndex();
      expect(index).assertEqual(BigFolderViewModelInstance.getIndex());
    })
    it('test_getAddListColumn', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const addListColumn: number = BigFolderViewModelInstance.getAddListColumn();
      expect(addListColumn).assertEqual(BigFolderViewModelInstance.getAddListColumn());
    })
    it('test_removeFolderAfterUninstallIfNeeded', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const openFolderData: GridLayoutItemInfo = {
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      const folderAppList: GridLayoutItemInfo[] = [{
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }]
      expect(BigFolderViewModelInstance.removeFolderAfterUninstallIfNeeded(openFolderData, folderAppList, '1') === undefined)
        .assertTrue();
    })
    it('test_ removeFolderAfterUninstallWithoutClose', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const openFolderData: GridLayoutItemInfo = {
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      const folderAppList: GridLayoutItemInfo[] = [{
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }]
      expect(BigFolderViewModelInstance.removeFolderAfterUninstallWithoutClose(openFolderData, folderAppList, '1') === undefined)
        .assertTrue();
    })
    it('test_getAppListInFolder', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const centerAniX: number = 0;
      const centerAniY: number = 0;
      const layoutInfo: Array<GridLayoutItemInfo[]> = [[{
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        typeId: 4,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }]];
      const openFolderData: GridLayoutItemInfo = {
        layoutInfo,
        bundleName,
        abilityName,
        appIconId,
        negativeId,
        isSelect,
        enterEditing,
        downloadProgress,
        appStatus,
        iconResource,
        callerName,
        centerAniX,
        centerAniY,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      }
      const appListInFolder: GridLayoutItemInfo[] = BigFolderViewModelInstance.getAppListInFolder(openFolderData);
      expect(appListInFolder).assertDeepEquals(BigFolderViewModelInstance.getAppListInFolder(openFolderData));
    })

    it('test_getIconArray_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_getPreviewContentWidth_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_dealWantParms_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('test_calculatePreviewHeight_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('test_createRelativePath_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('test_getIconArray_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_getPreviewContentWidth_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_dealWantParms_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('test_calculatePreviewHeight_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('test_createRelativePath_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('test_getIconArray_03', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_getPreviewContentWidth_03', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_dealWantParms_03', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('test_calculatePreviewHeight_03', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('test_createRelativePath_03', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('test_getIconArray_04', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_getPreviewContentWidth_04', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_dealWantParms_04', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('test_calculatePreviewHeight_04', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('test_createRelativePath_04', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('test_getIconArray_05', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_getPreviewContentWidth_05', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_dealWantParms_05', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('test_calculatePreviewHeight_05', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('test_createRelativePath_05', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('test_getIconArray_06', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_getPreviewContentWidth_06', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_dealWantParms_06', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('test_calculatePreviewHeight_06', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('test_createRelativePath_06', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('test_getIconArray_07', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_getPreviewContentWidth_07', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_dealWantParms_07', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('test_calculatePreviewHeight_07', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('test_createRelativePath_07', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('test_getIconArray_08', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_getPreviewContentWidth_08', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_dealWantParms_08', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('test_calculatePreviewHeight_08', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('test_createRelativePath_08', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('test_getIconArray_09', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_getPreviewContentWidth_09', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_dealWantParms_09', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('test_calculatePreviewHeight_09', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('test_createRelativePath_09', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('test_getIconArray_10', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_getPreviewContentWidth_10', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_dealWantParms_10', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('test_calculatePreviewHeight_10', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('test_createRelativePath_10', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('test_getIconArray_11', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
  })
}