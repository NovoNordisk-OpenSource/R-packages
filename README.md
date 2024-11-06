# R-packages

Homepage for [R packages developed at Novo Nordisk](https://novonordisk-opensource.github.io/R-packages/).

## Build information

* Webpage is automatically build and deployed using GitHub Actions.
* Build using Quarto and R, where version and packages are locked using {renv}.
* The webpage relies on metadata and generates content dynamically based on it. This is done in `RUNME.R`.

## Metadata

### Packages

Packages are defined in `packages.yaml`. Each package has the following entry:

``` yaml
  - name: {Organisation}/{Repository}
    categories:
      - {free text category 1}
      - {free text category 2}
      ...
```

The categories are used to allow easy filtering on the package overview subpage,
so make sure to re-use categories when applicable.

### Ressources

Linked presentations etc. are defined in `ressources.yaml`. Each entry has the following format:

``` yaml
  - date: {DDMMMYYYY}
    presentation:
      name: "{Presentation name}"
      link: {Presentation link}
    event: 
      name: {Event name}
      link: {Event link}
    presenters: 
      - name: {Presenter 1}
        link: {link to presenter info/webpage/linkedin}
      - name: {Presenter 2}
        link: {link to presenter info/webpage/linkedin}
      ...
```

Note that for each element providing at `link` is only optional.
