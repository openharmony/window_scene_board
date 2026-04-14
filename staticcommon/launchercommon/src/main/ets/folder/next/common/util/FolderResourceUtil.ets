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

import { ResUtils } from '@ohos/windowscene';

/**
 * 文件夹资源工具类
 */
export class FolderResourceUtil {
  private static sFolderBgRadius: number = 0;
  private static sFolderBgSaturation: number = 0;
  private static sSolidBgColor: Resource;
  private static sNotSolidBgColor: Resource;

  /**
   * 获取背板颜色饱和度
   *
   * @returns 饱和度
   */
  public static getFolderBgSaturation(): number {
    if (FolderResourceUtil.sFolderBgSaturation === 0) {
      FolderResourceUtil.sFolderBgSaturation = ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_saturation'));
    }
    return FolderResourceUtil.sFolderBgSaturation;
  }

  /**
   * 获取文件夹背板圆点
   *
   * @returns 背板圆角值
   */
  public static getFolderBgRadius(): number {
    if (FolderResourceUtil.sFolderBgRadius === 0) {
      FolderResourceUtil.sFolderBgRadius = ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_radius'));
    }
    return FolderResourceUtil.sFolderBgRadius;
  }
  
  /**
   * 获取是否背板颜色
   * 
   * @param isSolid
   * @returns 
   */
  public static getBgColor(isSolid: boolean): Resource {
    if (isSolid) {
      if (!FolderResourceUtil.sSolidBgColor) {
        FolderResourceUtil.sSolidBgColor = $r('app.color.low_back_plane_bg_color');
      }
      return FolderResourceUtil.sSolidBgColor;
    } else {
      if (!FolderResourceUtil.sNotSolidBgColor) {
        FolderResourceUtil.sNotSolidBgColor = $r('app.color.back_plane_bg_color');
      }
      return FolderResourceUtil.sNotSolidBgColor
    }
  }
}