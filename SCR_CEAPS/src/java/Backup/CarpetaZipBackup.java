/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Backup;

/**
 *
 * @author ALEJO (COL)
 */

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;


/**
 * Create zip of folder
 * 
 * @author Nitesh Apte
 * @version 1.0
 * @license GPL
 */
public class CarpetaZipBackup{
  
  public Boolean zipFolder(String srcFolder, String destZipFile) throws Exception {
    ZipOutputStream zip;
    FileOutputStream fileWriter;

    fileWriter = new FileOutputStream(destZipFile);
    zip = new ZipOutputStream(fileWriter);
    addFolderToZip(srcFolder, zip);
    zip.flush();
    zip.close();
    return true;
  }

  public void addFileToZip(String srcFile, ZipOutputStream zip) throws Exception {
    File folder = new File(srcFile);
    if (folder.isDirectory()) {
      addFolderToZip(srcFile, zip);
    } else {
      byte[] buf = new byte[1024];
      int len;
      FileInputStream in = new FileInputStream(srcFile);
      zip.putNextEntry(new ZipEntry("/" + folder.getName()));
      while ((len = in.read(buf)) > 0) {
        zip.write(buf, 0, len);
      }
    }
  }

  public void addFolderToZip(String srcFolder, ZipOutputStream zip) throws Exception {
    File folder = new File(srcFolder);
    for (String fileName : folder.list()) {
      addFileToZip(srcFolder + "/" + fileName, zip);
    }
  }
}