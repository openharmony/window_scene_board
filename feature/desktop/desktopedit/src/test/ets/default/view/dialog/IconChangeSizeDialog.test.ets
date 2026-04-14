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
    when
} from '@ohos/hypium';
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

export function IconChangeSizeDataTest() {
    describe('IconChangeSizeDataTest', () => {
        beforeAll(() => {
        })

        beforeEach(() => {
        })

        afterEach(() => {
        })

        afterAll(() => {
        })
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

    it('test_GridOccupyStatus_create', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        expect(instance.getSizeX()).assertEqual(4);
        expect(instance.getSizeY()).assertEqual(4);
        instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect', Level.LEVEL0, (): void => {
        instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus01', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(5 << 3, 3 << 4, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[1][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.toString();
    })


    it('test_GridOccupyStatus_markStatus01', Level.LEVEL0, (): void => {
        instance.markStatus(5 << 3, 5 << 4, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(3 << 5, 5 << 5, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(1, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(5, 0, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(5, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create01', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.getGridOccupyStatus()[3][0]).assertEqual(GridOccupyStatusEnum.FREE);
        expect(instance.getSizeX()).assertEqual(4);
        expect(instance.getSizeY()).assertEqual(4);
        instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied01', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid01', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect01', Level.LEVEL0, (): void => {
        instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 3, 3, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom01', Level.LEVEL0, (): void => {
        instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus01', Level.LEVEL0, (): void => {
        let cellX:number = -4;
        let cellY:number = 4;
        expect(instance.getStatus(cellX,cellY));
        cellX = 5;
        cellY = -5;
        expect(instance.getStatus(cellX,cellY));
        cellX = 6;
        cellY = 7;
        expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree01', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 3, 1 << 5)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus01', Level.LEVEL0, (): void => {
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan01', Level.LEVEL0, (): void => {
        let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus05', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.toString();
    })


    it('test_GridOccupyStatus_markStatus05', Level.LEVEL0, (): void => {
        instance.markStatus(3 << 6, 3 << 7, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 7)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(1 << 5, 5 << 7, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 7)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create05', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.getGridOccupyStatus()[0][1]).assertEqual(GridOccupyStatusEnum.FREE);
        expect(instance.getSizeX()).assertEqual(4);
        expect(instance.getSizeY()).assertEqual(4);
        instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied02', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid02', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 1, 1, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 2, 2, GridOccupyStatusEnum.FREE)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 3, 3, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect02', Level.LEVEL0, (): void => {
        instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom02', Level.LEVEL0, (): void => {
        instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_getStatus02', Level.LEVEL0, (): void => {
        let cellX:number = -1;
        let cellY:number = 1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = -1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = 1;
        expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree02', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
        expect(instance.isOccupied(1, 1)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus02', Level.LEVEL0, (): void => {
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan02', Level.LEVEL0, (): void => {
        let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus03', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][1]).assertEqual(GridOccupyStatusEnum.FREE);
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        instance.toString();
    })


    it('test_GridOccupyStatus_markStatus03', Level.LEVEL0, (): void => {
        instance.markStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create03', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        expect(instance.getSizeX()).assertEqual(4);
        instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied03', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid03', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect03', Level.LEVEL0, (): void => {
        instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom03', Level.LEVEL0, (): void => {
        instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus03', Level.LEVEL0, (): void => {
        let cellX:number = -1;
        let cellY:number = 1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = -1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = 1;
        expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree03', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus03', Level.LEVEL0, (): void => {
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })


    it('test_GridOccupyStatus_create08', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        expect(instance.getSizeX()).assertEqual(4);
        expect(instance.getSizeY()).assertEqual(4);
        instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied08', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid08', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect08', Level.LEVEL0, (): void => {
        instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom08', Level.LEVEL0, (): void => {
        instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus08', Level.LEVEL0, (): void => {
        let cellX:number = -1;
        let cellY:number = 1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = -1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = 1;
        expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree08', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus08', Level.LEVEL0, (): void => {
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan08', Level.LEVEL0, (): void => {
        let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus08', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.toString();
    })

    it('test_GridOccupyStatus_isInStatus09', Level.LEVEL0, (): void => {
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan09', Level.LEVEL0, (): void => {
        let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus09', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.toString();
    })


    it('test_GridOccupyStatus_markStatus09', Level.LEVEL0, (): void => {
        instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create09', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        expect(instance.getSizeX()).assertEqual(4);
        expect(instance.getSizeY()).assertEqual(4);
        instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied09', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid09', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect09', Level.LEVEL0, (): void => {
        instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom09', Level.LEVEL0, (): void => {
        instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus09', Level.LEVEL0, (): void => {
        let cellX:number = -1;
        let cellY:number = 1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = -1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = 1;
        expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_create10', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        expect(instance.getSizeX()).assertEqual(4);
        expect(instance.getSizeY()).assertEqual(4);
        instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied10', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid10', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect10', Level.LEVEL0, (): void => {
        instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom10', Level.LEVEL0, (): void => {
        instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus10', Level.LEVEL0, (): void => {
        let cellX:number = -1;
        let cellY:number = 1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = -1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = 1;
        expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree10', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus10', Level.LEVEL0, (): void => {
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan10', Level.LEVEL0, (): void => {
        let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus10', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.toString();
    })


    it('test_GridOccupyStatus_markStatus10', Level.LEVEL0, (): void => {
        instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create10', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        expect(instance.getSizeX()).assertEqual(4);
        expect(instance.getSizeY()).assertEqual(4);
        instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied10', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isOccupied11', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid11', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect11', Level.LEVEL0, (): void => {
        instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom11', Level.LEVEL0, (): void => {
        instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus11', Level.LEVEL0, (): void => {
        let cellX:number = -1;
        let cellY:number = 1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = -1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = 1;
        expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree11', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus11', Level.LEVEL0, (): void => {
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan11', Level.LEVEL0, (): void => {
        let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus11', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.toString();
    })


    it('test_GridOccupyStatus_markStatus11', Level.LEVEL0, (): void => {
        instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create11', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        expect(instance.getSizeX()).assertEqual(4);
        expect(instance.getSizeY()).assertEqual(4);
        instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied11', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid11', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect11', Level.LEVEL0, (): void => {
        instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom11', Level.LEVEL0, (): void => {
        instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus11', Level.LEVEL0, (): void => {
        let cellX:number = -1;
        let cellY:number = 1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = -1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = 1;
        expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree11', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus11', Level.LEVEL0, (): void => {
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan11', Level.LEVEL0, (): void => {
        let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus11', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.toString();
    })

    it('test_GridOccupyStatus_isInStatus11', Level.LEVEL0, (): void => {
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan11', Level.LEVEL0, (): void => {
        let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus11', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.toString();
    })


    it('test_GridOccupyStatus_markStatus11', Level.LEVEL0, (): void => {
        instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create11', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        expect(instance.getSizeX()).assertEqual(4);
        expect(instance.getSizeY()).assertEqual(4);
        instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied11', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid11', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect11', Level.LEVEL0, (): void => {
        instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom11', Level.LEVEL0, (): void => {
        instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus11', Level.LEVEL0, (): void => {
        let cellX:number = -1;
        let cellY:number = 1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = -1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = 1;
        expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_create10', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        expect(instance.getSizeX()).assertEqual(4);
        expect(instance.getSizeY()).assertEqual(4);
        instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied12', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid12', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect12', Level.LEVEL0, (): void => {
        instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom12', Level.LEVEL0, (): void => {
        instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus12', Level.LEVEL0, (): void => {
        let cellX:number = -1;
        let cellY:number = 1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = -1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = 1;
        expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree12', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus12', Level.LEVEL0, (): void => {
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan12', Level.LEVEL0, (): void => {
        let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus12', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.toString();
    })

    it('test_GridOccupyStatus_markStatus12', Level.LEVEL0, (): void => {
        instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create12', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        expect(instance.getSizeX()).assertEqual(4);
        expect(instance.getSizeY()).assertEqual(4);
        instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied12', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid12', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid14', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect14', Level.LEVEL0, (): void => {
        instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom14', Level.LEVEL0, (): void => {
        instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus14', Level.LEVEL0, (): void => {
        let cellX:number = -1;
        let cellY:number = 1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = -1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = 1;
        expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree14', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus14', Level.LEVEL0, (): void => {
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan14', Level.LEVEL0, (): void => {
        let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus14', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.toString();
    })


    it('test_GridOccupyStatus_markStatus14', Level.LEVEL0, (): void => {
        instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
        expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
    })

    it('test_GridOccupyStatus_create14', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        expect(instance.getSizeX()).assertEqual(4);
        expect(instance.getSizeY()).assertEqual(4);
        instance.toString();
    })

    it('test_GridOccupyStatus_isOccupied14', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatusForGrid14', Level.LEVEL0, (): void => {
        expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.FREE)).assertFalse();
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
        instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForRect14', Level.LEVEL0, (): void => {
        instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
    })

    it('test_GridOccupyStatus_copyFrom14', Level.LEVEL0, (): void => {
        instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
    })

    it('test_GridOccupyStatus_getStatus14', Level.LEVEL0, (): void => {
        let cellX:number = -1;
        let cellY:number = 1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = -1;
        expect(instance.getStatus(cellX,cellY));
        cellX = 1;
        cellY = 1;
        expect(instance.getStatus(cellX,cellY));
    })

    it('test_GridOccupyStatus_isFree14', Level.LEVEL0, (): void => {
        expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
        expect(instance.isOccupied(1, 1)).assertTrue();
        expect(instance.isFree(0, 0)).assertTrue();
    })

    it('test_GridOccupyStatus_isInStatus13', Level.LEVEL0, (): void => {
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
        expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan13', Level.LEVEL0, (): void => {
        let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus05', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.toString();
    })

    it('test_GridOccupyStatus_markGridForCellAndSpan14', Level.LEVEL0, (): void => {
        let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
        expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
    })

    it('test_GridOccupyStatus_getGridOccupyStatus14', Level.LEVEL0, (): void => {
        expect(instance.getGridOccupyStatus()).assertNull();
        instance = new GridOccupyStatus(1 << 5, 1 << 5, GridOccupyStatusEnum.FREE);
        expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
        instance.toString();
    })


    it('test_getDragStartInDesktopEvent_should_return_string08', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_cancelDropAnimation08', Level.LEVEL0, (): void => {
        let context: ServiceExtensionContext = GlobalContext.getContext();
        if (context != null) {
            let dropAnimationEndReason: number = -1;
            let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
            context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
            AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
            DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
            expect(dropAnimationEndReason).assertEqual(-1);
            AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
            DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
            expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
            DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
            expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
            context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
        } else {
            checkNotFail(() => DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END));
        }
    })

    it('test_isDropInDesktop08', Level.LEVEL0, (): void => {
        DragEventManager.getInstance().dragStartInDesktop(0);
        expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
        DragEventManager.getInstance().startDrop(0);
        expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('IconChangeWantDataTest_getInstance_should_not_null09', Level.LEVEL0, (): void => {
        expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string09', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string09', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string09', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string09', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string09', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string09', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string09', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_cancelDropAnimation09', Level.LEVEL0, (): void => {
        let context: ServiceExtensionContext = GlobalContext.getContext();
        if (context != null) {
            let dropAnimationEndReason: number = -1;
            let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
            context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
            AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
            DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
            expect(dropAnimationEndReason).assertEqual(-1);
            AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
            DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
            expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
            DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
            expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
            context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
        } else {
            checkNotFail(() => DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END));
        }
    })

    it('test_isDropInDesktop09', Level.LEVEL0, (): void => {
        DragEventManager.getInstance().dragStartInDesktop(0);
        expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
        DragEventManager.getInstance().startDrop(0);
        expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('IconChangeWantDataTest_getInstance_should_not_null10', Level.LEVEL0, (): void => {
        expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string10', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string10', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string10', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string10', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string10', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string10', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string10', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_isDropInDesktop10', Level.LEVEL0, (): void => {
        DragEventManager.getInstance().dragStartInDesktop(0);
        expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
        DragEventManager.getInstance().startDrop(0);
        expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('IconChangeWantDataTest_getInstance_should_not_null11', Level.LEVEL0, (): void => {
        expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string11', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string11', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string11', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string11', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string11', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string11', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string11', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_isDropInDesktop11', Level.LEVEL0, (): void => {
        DragEventManager.getInstance().dragStartInDesktop(0);
        expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
        DragEventManager.getInstance().startDrop(0);
        expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('IconChangeWantDataTest_getInstance_should_not_null12', Level.LEVEL0, (): void => {
        expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string12', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string12', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string12', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string12', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string12', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string12', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string12', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_isDropInDesktop12', Level.LEVEL0, (): void => {
        DragEventManager.getInstance().dragStartInDesktop(0);
        expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
        DragEventManager.getInstance().startDrop(0);
        expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('IconChangeWantDataTest_getInstance_should_not_null13', Level.LEVEL0, (): void => {
        expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string13', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string13', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string13', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string13', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string13', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string13', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string13', Level.LEVEL0, (): void => {
        let itemKey: string = 'appItem';
        let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
        expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

        let itemId: number = 123;
        let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
        expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_isDropInDesktop13', Level.LEVEL0, (): void => {
        DragEventManager.getInstance().dragStartInDesktop(0);
        expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
        DragEventManager.getInstance().startDrop(0);
        expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('IconChangeWantDataTest_getInstance_should_not_null14', Level.LEVEL0, (): void => {
        expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string14', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string14', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string14', Level.LEVEL0, (): void => {
        let groupId: string = 'grid';
        let pageIndex: number = 1;
        let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
        expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })
}