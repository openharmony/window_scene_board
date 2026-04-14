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

import { GlobalStatusCache } from '@ohos/screenlockcommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { QuickToolConstants, QuickToolsState } from '../common/QuickToolConstants';

const TAG: string = 'QuickToolUtil';
const log = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class QuickToolUtil {
  private static instance: QuickToolUtil;

  private constructor() {
  }

  public static getInstance(): QuickToolUtil {
    if (!QuickToolUtil.instance) {
      QuickToolUtil.instance = new QuickToolUtil();
    }
    return QuickToolUtil.instance;
  }

  public setToolsState(toolsState: number): void {
    GlobalStatusCache.getInstance().setStatus(QuickToolConstants.CACHE_KEY_TOOLS_STATE, toolsState);
  }

  public getToolsState(): number {
    return GlobalStatusCache.getInstance()
      .getStatus(QuickToolConstants.CACHE_KEY_TOOLS_STATE, QuickToolsState.CLOSE) as number;
  }

  public setToolsUsing(toolsState: boolean): void {
    GlobalStatusCache.getInstance().setStatus(QuickToolConstants.CACHE_KEY_IS_TOOLS_USING, toolsState);
  }

  public getToolsUsing(): boolean {
    return GlobalStatusCache.getInstance().getStatus(QuickToolConstants.CACHE_KEY_IS_TOOLS_USING, false) as boolean;
  }

  public setFlashState(isFlashOpen: boolean): void {
    GlobalStatusCache.getInstance().setStatus(QuickToolConstants.CACHE_KEY_IS_FLASH_OPEN, isFlashOpen);
  }

  public getFlashState(): boolean {
    return GlobalStatusCache.getInstance()
      .getStatus(QuickToolConstants.CACHE_KEY_IS_FLASH_OPEN, false) as boolean;
  }

  public setFlashAvailableState(isFlashAvailable: boolean): void {
    GlobalStatusCache.getInstance().setStatus(QuickToolConstants.CACHE_KEY_IS_FLASH_AVAILABLE, isFlashAvailable);
  }

  public getFlashAvailableState(): boolean {
    return GlobalStatusCache.getInstance()
      .getStatus(QuickToolConstants.CACHE_KEY_IS_FLASH_AVAILABLE, true) as boolean;
  }

  public setHotZoneX(hotZoneX: number): void {
    GlobalStatusCache.getInstance().setStatus(QuickToolConstants.CACHE_KEY_HOT_ZONE_X, hotZoneX);
  }

  public getHotZoneX(): number {
    return GlobalStatusCache.getInstance().getStatus(QuickToolConstants.CACHE_KEY_HOT_ZONE_X, 0) as number;
  }

  public setHotZoneY(hotZoneY: number): void {
    GlobalStatusCache.getInstance().setStatus(QuickToolConstants.CACHE_KEY_HOT_ZONE_Y, hotZoneY);
  }

  public getHotZoneY(): number {
    return GlobalStatusCache.getInstance().getStatus(QuickToolConstants.CACHE_KEY_HOT_ZONE_Y, 0) as number;
  }
}