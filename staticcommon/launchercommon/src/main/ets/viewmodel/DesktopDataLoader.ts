/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, Log, LogDomain, LogHelper, SingleBase, SingleContext, singleManager } from '@ohos/basicutils';
import { DesktopLayoutCacheData } from '../cache/layout/DesktopLayoutCacheData';
import { CommonConstants, DesktopLayoutState } from '../constants/CommonConstants';
import {
    DefaultDesktopLayoutInfo,
    DockItemInfo,
    FolderLayoutCacheManager,
    FormLayoutCacheManager,
    GetLayoutInfoFromConfig, GridLayoutItemInfo,
    LaunchLayoutCacheManager,
    PadLaunchLayoutCacheManager,
    CommonDockModel,
    PageInfoManager,
    RdbStoreManager
} from '../TsIndex';

const TAG = 'DesktopDataLoader';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Desktop data loader
 */
export class DesktopDataLoader extends SingleBase {
    public static singleName: string = 'DesktopDataLoader';
    protected mRdbStoreManager?: RdbStoreManager;

    private mDesktopModel: number = 0;

    public constructor(ctx?: SingleContext) {
        super(ctx);
    }

    static getInstance(desktopModel: number, ctx?: SingleContext): DesktopDataLoader {
        let instance = singleManager.get<DesktopDataLoader>(DesktopDataLoader, ctx);
        instance.initDesktopLayout(desktopModel);
        return instance;
    }

    public initDesktopLayout(desktopModel: number): void {
        Log.showInfo(TAG, `${DesktopDataLoader.singleName} initBaseConfig start`);
        this.mRdbStoreManager = RdbStoreManager.getInstance();
        this.mDesktopModel = desktopModel;
        this.mRdbStoreManager.updateLayoutTableName(this.mDesktopModel);
    }

    public async loadPageCount(): Promise<number> {
        return this.mRdbStoreManager?.querySettingsPageCount() ?? 0;
    };

    public async loadMaxFormCount(): Promise<number> {
        return this.mRdbStoreManager?.querySettingsMaxFormCount() ?? 0;
    };

    public async loadGridLayoutItemsFromRdb(): Promise<GridLayoutItemInfo[]> {
        return this.mRdbStoreManager?.queryGridLayoutInfo() ?? [];
    };

    public async loadSmartDockItemsFromRdb(): Promise<DockItemInfo[]> {
        return CommonDockModel.getInstance().querySmartDock();
    }

    public async loadFromJsonConfig(): Promise<DefaultDesktopLayoutInfo> {
      if (this.mDesktopModel === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
        return GetLayoutInfoFromConfig.getInstance(this.singleContext).getSimpleLayoutConfigFile();
      } else if (this.mDesktopModel === DesktopLayoutState.PC_MODE_MODEL) {
        return GetLayoutInfoFromConfig.getInstance(this.singleContext).get2in1PcLayoutConfigFile();
      } else {
        return GetLayoutInfoFromConfig.getInstance(this.singleContext).getAllLayoutConfigFile();
      }
    }

    public async loadDesktopLayout(): Promise<boolean> {
        let pageCount: number = await this.loadPageCount();
        PageInfoManager.getInstance().updatePageCount(pageCount, 'loadDesktopLayout');
        let gridLayoutInfos: GridLayoutItemInfo[] = await this.loadGridLayoutItemsFromRdb();
        let dockItemInfos: DockItemInfo[] = await this.loadSmartDockItemsFromRdb();
        log.showInfo(`loadPersistConfig -> RdbStoreManager.pageCount: ${pageCount}, configFromRdb.length: ${gridLayoutInfos.length}`);
        if (!CheckEmptyUtils.isEmptyArr(gridLayoutInfos) || !CheckEmptyUtils.isEmptyArr(dockItemInfos)) {
            let layoutInfo: DefaultDesktopLayoutInfo = this.mDesktopModel === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL ?
              DefaultDesktopLayoutInfo.getSimpleLayoutInfo() : DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
            layoutInfo.layoutInfo = gridLayoutInfos;
            layoutInfo.layoutDescription.pageCount = pageCount;
            this.initLayoutCache(layoutInfo);
            return true;
        }
        return false;
    }

    public initLayoutCache(layoutInfo: DefaultDesktopLayoutInfo): void {
        let layoutData: DesktopLayoutCacheData = new DesktopLayoutCacheData(layoutInfo);
        let outerGridLayout: DefaultDesktopLayoutInfo = LaunchLayoutCacheManager.getInstance().getOuterInfo();
        layoutData.setGridLayoutInfo(outerGridLayout, true);
        layoutData.setGridLayoutItemList(outerGridLayout.layoutInfo, true);
        LaunchLayoutCacheManager.getInstance().reInit(layoutData);
        PadLaunchLayoutCacheManager.getInstance().reInit(layoutData);
        FormLayoutCacheManager.getInstance().reInit(layoutData);
        FolderLayoutCacheManager.getInstance().reInit(layoutData);
    }
}