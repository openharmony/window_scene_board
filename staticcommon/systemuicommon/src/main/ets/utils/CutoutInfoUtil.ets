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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { Singleton } from '../utils/Singleton';
import { display } from '@kit.ArkUI';
import { LogWithHa } from '../maintenance/CommonExceptionMaintenance';
import { SystemUICommonUtil } from './SystemUICommonUtil';
import { deviceInfo } from '@kit.BasicServicesKit';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuiutils/src/main/ets/base/LayoutUtils';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'CutoutInfoUtil');

interface CutoutInfoDiff {
  leftDiff: number,
  topDiff: number,
  widthDiff: number,
  heightDiff: number
}

const ALN_DIFF: CutoutInfoDiff = {
  leftDiff: 0,
  topDiff: 0,
  widthDiff: 0,
  heightDiff: 4
}
/**
 * 设备信息ViewModel
 */
export class CutoutInfoUtil {
  @Singleton.decorate()
  public static get instance(): CutoutInfoUtil {
    return new CutoutInfoUtil();
  }

  /**
   * 孔信息缓存
   * key值组成：width_height_orientation
   */
  private cutoutMap: Map<string, display.CutoutInfo> = new Map();

  private displayModeMap: Map<string, XTLayoutType> = new Map();

  private constructor() {
    this.getALLPhysicalDisplayInfo();
  }

  private async getALLPhysicalDisplayInfo(): Promise<void> {
    if (!LayoutUtils.isXTProductType()) {
      return;
    }
    const resolutionObjects = await display.getAllDisplayPhysicalResolution();
    for (let i = 0; i < resolutionObjects.length; i++) {
      const physicalWidth = resolutionObjects[i].physicalWidth;
      const physicalHeight = resolutionObjects[i].physicalHeight;
      const foldDisplayMode = resolutionObjects[i].foldDisplayMode;
      log.showInfo(`physicalWidth: ${physicalWidth}, physicalHeight: ${physicalHeight}, foldDisplayMode: ${foldDisplayMode}`);
      if (foldDisplayMode === display.FoldDisplayMode.FOLD_DISPLAY_MODE_MAIN) {
        this.displayModeMap.set(`${physicalWidth}-${physicalHeight}`, XTLayoutType.F);
        this.displayModeMap.set(`${physicalHeight}-${physicalWidth}`, XTLayoutType.F);
      } else if (physicalWidth > physicalHeight) {
        this.displayModeMap.set(`${physicalWidth}-${physicalHeight}`, XTLayoutType.G);
        this.displayModeMap.set(`${physicalHeight}-${physicalWidth}`, XTLayoutType.G);
      } else {
        this.displayModeMap.set(`${physicalWidth}-${physicalHeight}`, XTLayoutType.M);
        this.displayModeMap.set(`${physicalHeight}-${physicalWidth}`, XTLayoutType.M);
      }
    }
  }

  public getXTLayoutTypeFromCache(defaultDisplay: display.Display): XTLayoutType | undefined {
    const key = `${defaultDisplay.width}-${defaultDisplay.height}`
    return this.displayModeMap.get(key);
  }

  public async getCutoutInfo(defaultDisplay: display.Display): Promise<display.CutoutInfo> {
    try {
      let data = await defaultDisplay.getCutoutInfo();
      if (!data?.boundingRects || data.boundingRects.length === 0) {
        return data;
      }
      if (this.getXTLayoutTypeFromCache(defaultDisplay) === XTLayoutType.M) {
        // 如果是M态确返回了挖孔信息，说明dms返回异常，需要清空
        log.showWarn(`get cutoutInfo error with M state, clear it`);
        data.boundingRects.splice(0, data.boundingRects.length);
        return data;
      }
      // ALN设备ccm配置的挖孔信息错误，需加上一个误差进行校准
      if (defaultDisplay.orientation === display.Orientation.PORTRAIT) {
        if (deviceInfo.productSeries.includes('ALN')) {
          data.boundingRects[0].left += ALN_DIFF.leftDiff;
          data.boundingRects[0].top += ALN_DIFF.topDiff;
          data.boundingRects[0].width += ALN_DIFF.widthDiff;
          data.boundingRects[0].height += ALN_DIFF.heightDiff;
        }
      }
      return data;
    } catch (err) {
      throw new Error(`get cutout info error, code is ${err.code}, message is ${err.message}`);
    }
  }
}
