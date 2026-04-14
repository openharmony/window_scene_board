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

import lazy { ThemeConstant } from './ThemeConstant';
import lazy { FileUtil } from './FileUtil';
import { Log } from './Log';

const TAG: string = 'EngineService-ThemePermissionParser';

/**
 * 主题包解析类
 *
 * @since 2024-08-29
 */
export class ThemePermissionParser {
  /**
   * 解析主题包信息
   *
   * @param themePath 主题包的路径，eg：/sys_prod/.../themes/theme/default  ThemeOptions 使能参数
   * @returns 返回一个Promise，包含所有主题包所需权限
   */
  public async parse(themePath: string | undefined): Promise<string[]> {
    if (!themePath || themePath === undefined) {
      Log.warn(TAG, `themePath is null`);
      return [];
    }
    Log.info(TAG, `parse fileName = ${FileUtil.getFileName(themePath)}`);

    let homeManifest: string = await FileUtil.readManifestJson(`${themePath}/home/manifest.json`);
    let homePermission: string[] = this.parsePermission(homeManifest);
    let lockManifest: string = await FileUtil.readManifestJson(`${themePath}/lock/manifest.json`);
    let lockPermission: string[] = this.parsePermission(lockManifest);
    let longTakeManifest: string = await FileUtil.readManifestJson(`${themePath}/long_take/manifest.json`);
    let longTakePermission: string[] = this.parsePermission(longTakeManifest);
    let faManifest: string = await FileUtil.readManifestJson(`${themePath}/fa/manifest.json`);
    let faPermission: string[] = this.parsePermission(faManifest);

    // 需要授权的权限列表
    let permissionList: string[] =
      Array.from(new Set(homePermission.concat(lockPermission, longTakePermission, faPermission)));

    Log.debug(TAG, `permissionList = ${permissionList}`);
    return permissionList;
  }

  /**
   * 根据json内容解析所需权限
   *
   * @param permission 待解析json内容（已转string）
   * @returns 返回所需权限
   */
  private parsePermission(permission: string): string[] {
    if (!permission) {
      return [];
    }
    let permissions: string[] = permission.toString().split(',');
    Log.debug(TAG, `parsePermission = ${permissions}`);

    let resultPermission: string[] = [];
    for (let permission of permissions) {
      let result: string | undefined = ThemeConstant.PERMISSION_MAP.get(permission);
      if (result !== undefined) {
        resultPermission.push(result);
      }
    }
    return resultPermission;
  }
}
