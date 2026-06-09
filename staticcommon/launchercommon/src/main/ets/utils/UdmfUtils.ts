/**
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

import type UDC from '@ohos.data.unifiedDataChannel';
import UTD from '@ohos.data.uniformTypeDescriptor';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';

export class UdmfUtils {
  private static readonly FOLDER_TYPE: number = 5;
  /**
  * 从record中获取数据
  * @param record UnifiedData中的单条文件记录
  * @param type 改record数据所属文件类别
  */
  public static getRecordData(record: UDC.UnifiedRecord, type: string): string {
    let recordData = '';
    switch (type) {
      case UTD.UniformDataType.FILE:
        let file = (record) as UDC.File;
        recordData = file.uri;
        break;
      case UTD.UniformDataType.IMAGE:
        let image = (record) as UDC.Image;
        recordData = image.imageUri;
        break;
      case UTD.UniformDataType.VIDEO:
        let video = (record) as UDC.Video;
        recordData = video.videoUri;
        break;
      case UTD.UniformDataType.AUDIO:
        let audio = record as UDC.Audio;
        recordData = audio.audioUri;
        break;
      case UTD.UniformDataType.FOLDER:
        let folder = (record) as UDC.Folder;
        recordData = folder.folderUri;
        break;
      default:
        recordData = '';
        break;
    }
    return recordData;
  }
}
