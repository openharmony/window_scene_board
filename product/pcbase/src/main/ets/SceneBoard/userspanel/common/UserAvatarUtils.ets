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
import fileUri from '@ohos.file.fileuri';
import fs from '@ohos.file.fs';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';

const TAG = 'UserPanel-UserAvatarUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const AVATAR_CONFIG_PATH: string = '/sys_prod/resource/avatar/list.json';

interface IAvatarConfigJSON {
  list: UserIconJson[];
}

class UserIconJson {
  public type: string = '';
  public path: string = '';
  public name: string = '';
  public defaultImg: string = '';
}

enum IconImgType {
  CLIP = '0',
  STATIC = '1',
  EMOJI = '2',
  EMOJI_3D = '3',
}

const STATIC_IMG_TYPES: string[] = [
  IconImgType.STATIC,
  IconImgType.EMOJI,
  IconImgType.EMOJI_3D,
];

export class UserAvatarUtils {
  /**
   * 处理数据，获取有效的头像路径
   * @param photo osAccountInfo 信息中的 photo 数据
   * @returns 头像路径
   */
  public static getImgSrcFromPhoto(photo: string): string {
    log.debug('getImgSrcFromPhoto invoked');
    let userIconData: UserIconJson;
    let imgSrc: string = '';
    try {
      if (CheckEmptyUtils.isEmpty(photo)) {
        userIconData = UserAvatarUtils.getDefaultIconData();
      } else {
        userIconData = JSON.parse(photo) as UserIconJson;
      }
      const iconType: string = userIconData.type;
      if (STATIC_IMG_TYPES.includes(iconType)) {
        imgSrc = fileUri.getUriFromPath(userIconData.defaultImg);
      } else if (iconType === IconImgType.CLIP) {
        imgSrc = userIconData.defaultImg;
      } else {
        log.error(`invalid iconType ${iconType}`);
      }
    } catch (err) {
      log.error(`getImgSrcFromPhoto parse failed. Error ${err?.code} ${err?.message}`);
      return imgSrc;
    }
    return imgSrc;
  }

  /**
   * 构建默认头像
   * @returns 默认头像
   */
  public static getDefaultIconData(): UserIconJson {
    log.debug('getDefaultIconData invoked');
    let defaultIcon: UserIconJson = new UserIconJson();
    try {
      const configJsonData: IAvatarConfigJSON = JSON.parse(fs.readTextSync(AVATAR_CONFIG_PATH));
      const listJson: UserIconJson[] = configJsonData.list;
      const defaultIconData: UserIconJson = listJson[0];
      if (UserAvatarUtils.isFileExist(defaultIconData.defaultImg)) {
        defaultIcon = defaultIconData;
      }
    } catch (err) {
      log.error(`getDefaultIconData failed. Error ${err?.code} ${err?.message}`);
    }
    return defaultIcon;
  }

  /**
   * 根据路径判断文件是否存在
   * @param path 文件全路径
   * @returns 文件是否存在
   */
  public static isFileExist(path: string): boolean {
    log.debug('isFileExist invoked');
    try {
      return fs.accessSync(path);
    } catch (err) {
      log.error(`isFileExist failed. Error ${err?.code} ${err?.message}`);
      return false;
    }
  }
}